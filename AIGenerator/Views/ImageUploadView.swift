//
//  ImageUploadView.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//
import SwiftUI
import PhotosUI

struct ImageUploadView: View {
    @State private var selectedImage: UIImage?
    @State private var isShowingPhotoPicker = false
    @State private var isUploading = false
    @State private var uploadResult: String?
    @State private var error: Error?
    @State private var taskID: String?
    @State private var cartonResult: cartonModel?
    @State private var isFetchingResult = false

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
            } else {
                Text("Lütfen Bir Fotoğraf Seçin")
                    .frame(maxWidth: 300, maxHeight: 300)
                    .border(.gray)
            }

            HStack {
                Button("Fotoğraf Seç") {
                    isShowingPhotoPicker = true
                }
                
                Button("Fotoğrafı Yükle") {
                    uploadImage()
                }.disabled(selectedImage == nil || isUploading)
            }
            .padding()

            if isUploading {
                ProgressView("Yükleniyor...")
            }

            if let result = uploadResult {
                Text("Yükleme Başarılı!\nSonuç:\n\(result)")
                    .padding()
            }
            
            if let taskID = taskID, !isFetchingResult {
                Button("Sonucu Getir") {
                    fetchTaskResult(taskId: taskID)
                }
            }
            
            if isFetchingResult {
                ProgressView("Sonuç Alınıyor...")
            }
            
            if let cartonResult = cartonResult {
                Text("Sonuç URL: \(cartonResult.data?.resultURL ?? "URL Yok")")
                    .padding()
            }

            if let error = error {
                Text("Hata: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
     func uploadImage() {
            guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
         isUploading = true
         uploadResult = nil
         error = nil
         
         Task {
             do {
                 let client = ImageUploadClient()
                  let response = try await client.uploadImage(image: imageData, index: "0")
                 
                 uploadResult = "Request ID: \(response.requestID)\nTask ID: \(response.taskID)\nStatus Code: \(response.errorDetail.statusCode)"
                 self.taskID = response.taskID
             } catch {
                 self.error = error
                 print("Upload failed: \(error)")
             }
             isUploading = false
         }
     }
    
    func fetchTaskResult(taskId: String) {
        isFetchingResult = true
        cartonResult = nil
        error = nil
        
        Task {
            do {
                let client = getCartonClient()
                let result = try await client.getTaskResult(taskId: taskId)
                cartonResult = result
            } catch {
                self.error = error
            }
            isFetchingResult = false
        }
    }
}
