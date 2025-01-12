import Foundation

struct getCartonClient {

    func getTaskResult(taskId: String) async throws -> cartonModel? {
        
        guard let url = URL(string: APIEndpoint.getCartonURL+"\(taskId)") else {
            throw NetworkError.badUrl
        }
        print("get url \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.allHTTPHeaderFields = APIEndpoint.getHeaders
        
        printRequestDetails(request: request)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("Status Code: \(httpResponse.statusCode)")
             if let errorData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Server Error Data: \(errorData)")
                } else if let errorString = String(data: data, encoding: .utf8) {
                     print("Server Error String: \(errorString)")
                }
            throw NetworkError.badRequest(httpResponse.statusCode)
        }
         
          printResponseDetails(response: response as! HTTPURLResponse, data: data)

        do {
            let taskResult = try JSONDecoder().decode(cartonModel.self, from: data)
           
            return taskResult
        } catch let error as DecodingError {
            switch error {
            case .typeMismatch(let type, let context):
                print("Type mismatch error: \(type), \(context)")
            case .valueNotFound(let value, let context):
                print("Value not found error: \(value), \(context)")
            case .keyNotFound(let key, let context):
                print("Key not found error: \(key), \(context)")
            case .dataCorrupted(let context):
                print("Data corrupted error: \(context)")
            @unknown default:
                print("Unknown decoding error: \(error)")
            }
            throw NetworkError.decodingError
        } catch {
            print("Hata oluştu: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func printRequestDetails(request: URLRequest) {
       print("\n--- Get Request Details ---")
        if let url = request.url {
            print("Request URL: \(url.absoluteString)")
        }
        if let headers = request.allHTTPHeaderFields {
           print("Request Headers: \(headers)")
        }
    }
    private func printResponseDetails(response: HTTPURLResponse, data: Data) {
      print("\n--- Get Response Details ---")
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
