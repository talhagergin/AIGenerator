//
//  getCartoonClient.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//

import Foundation


struct getCartonClient {

    func getTaskResult(taskId: String) async throws -> cartonModel {
        
        guard let url = URL(string: APIEndpoint.getCartonURL+"\(taskId)") else {
            throw NetworkError.badUrl
        }
        print("get url \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.allHTTPHeaderFields = APIEndpoint.getHeaders

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("Status Code: \(httpResponse.statusCode)")
            throw NetworkError.badRequest(httpResponse.statusCode)
        }

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
}
