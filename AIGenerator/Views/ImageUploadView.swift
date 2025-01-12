import SwiftUI

struct ImageUploadView: View {
    @State private var selectedImage: UIImage?
    @State private var cartoonImage: UIImage?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
     @State private var showImage = false
    
     private let imageUploadClient = ImageUploadClient()
     private let getCartoonClient = getCartonClient()

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("Resim seçilmedi.")
                    .frame(width: 200, height: 200)
                    .border(Color.gray)
            }

             Button("Resim Seç") {
                            showImage.toggle()
                        }
                        .sheet(isPresented: $showImage, content: {
                            ImagePicker(selectedImage: $selectedImage)
                        })
            
            Button("Cartoonlaştır") {
                            Task {
                                await uploadAndFetchCartoon()
                            }
                        }
                        .disabled(selectedImage == nil || isLoading)

            
            if isLoading {
                            ProgressView("Lütfen Bekleyin...")
                        }

            if let cartoonImage = cartoonImage {
                Image(uiImage: cartoonImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
             if let errorMessage = errorMessage {
                 Text("Hata: \(errorMessage)")
                     .foregroundColor(.red)
             }
        }
        .padding()
    }

    func uploadAndFetchCartoon() async {
        isLoading = true
        errorMessage = nil

        guard let image = selectedImage?.jpegData(compressionQuality: 0.8) else {
             errorMessage = "Geçersiz resim verisi."
                isLoading = false
            return
        }

        do {
           
            guard let taskId = try await imageUploadClient.uploadImage(image: image, index: "0", mimeType: "image/jpeg") else{
                errorMessage = "Task ID alınırken bir sorun oluştu"
                isLoading = false
                return
            }
            
             var fetchedCartoonImage : cartonModel?
           
            while (fetchedCartoonImage?.data?.result_url == nil){
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 sn bekle
                fetchedCartoonImage = try await getCartoonClient.getTaskResult(taskId: taskId)
            }
                
            if let imageURL = fetchedCartoonImage?.data?.result_url, let url = URL(string: imageURL) {
                 if let (imageData, _) = try? await URLSession.shared.data(from: url), let uiImage = UIImage(data: imageData){
                     cartoonImage = uiImage
                 } else {
                      errorMessage = "Resim verisi alınamadı."
                  }
            } else {
                errorMessage = "Image url alınırken sorun oluştu."
            }
           
            
        } catch let error as NetworkError {
             errorMessage = "Ağ hatası: \(error)"
        } catch {
              errorMessage = "Bilinmeyen bir hata oluştu: \(error)"
        }

        isLoading = false
    }
}


/*
#Preview {
    ImageUploadView()
}
*/
