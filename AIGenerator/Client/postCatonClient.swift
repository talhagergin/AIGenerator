//
//  postCatonClient.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badRequest(Int)
    case invalidResponse
    case decodingError
    case fileError
    case uploadError(Error)
}

struct ImageUploadClient {
    func uploadImage(image: Data, index: String = "0", mimeType: String = "image/jpeg") async throws -> APIResponseModel {
        guard let url = URL(string: APIEndpoint.baseURL) else {
            throw NetworkError.badUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIEndpoint.postHeaders
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = createMultipartFormData(image: image, index: index, boundary: boundary, mimeType: mimeType)
        request.httpBody = httpBody
        
        printRequestDetails(request: request, httpBody: httpBody) // İstek detaylarını yazdır

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            printResponseDetails(response: httpResponse, data: data)  // Yanıt detaylarını yazdır
            
            guard (200...299).contains(httpResponse.statusCode) else {
                 if let errorData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Server Error Data: \(errorData)")
                } else if let errorString = String(data: data, encoding: .utf8) {
                     print("Server Error String: \(errorString)")
                }
                throw NetworkError.badRequest(httpResponse.statusCode)
            }
            
            let apiResponse = try JSONDecoder().decode(APIResponseModel.self, from: data)
            return apiResponse
        } catch let error as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.uploadError(error)
        }
    }

    private func createMultipartFormData(image: Data, index: String, boundary: String, mimeType: String) -> Data {
        var body = Data()

        let parameters: [[String: Any]] = [
            ["key": "task_type", "value": "async", "type": "text"],
            ["key": "image", "type": "file", "data": image, "filename": "file", "mimeType": mimeType],
            ["key": "index", "value": index, "type": "text"]
        ]

        for param in parameters {
            guard let key = param["key"] as? String else { continue }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"".data(using: .utf8)!)
                
            if let type = param["type"] as? String {
                if type == "text", let value = param["value"] as? String {
                    body.append("\r\n\r\n\(value)\r\n".data(using: .utf8)!)
                } else if type == "file",
                          let data = param["data"] as? Data,
                          let filename = param["filename"] as? String,
                          let mimeType = param["mimeType"] as? String {
                        body.append("; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                        body.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
                        body.append("\r\n".data(using: .utf8)!)
                        body.append(data)
                        body.append("\r\n".data(using: .utf8)!)
                }
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    private func printRequestDetails(request: URLRequest, httpBody: Data?) {
       print("\n--- Request Details ---")
        if let url = request.url {
            print("Request URL: \(url.absoluteString)")
        }
        if let headers = request.allHTTPHeaderFields {
           print("Request Headers: \(headers)")
        }
        if let body = httpBody, let bodyString = String(data: body, encoding: .utf8) {
           print("Request Body: \n\(bodyString)")
        } else {
           print("Request Body: (empty or not printable)")
        }
    }
    
    private func printResponseDetails(response: HTTPURLResponse, data: Data) {
      print("\n--- Response Details ---")
      print("Status Code: \(response.statusCode)")
       if let responseHeaders = response.allHeaderFields as? [String: String] {
           print("Response Headers: \(responseHeaders)")
       }
        
        if let responseString = String(data: data, encoding: .utf8) {
           print("Response Data: \n\(responseString)")
        } else {
           print("Response Data: (not printable)")
        }
   }
}
