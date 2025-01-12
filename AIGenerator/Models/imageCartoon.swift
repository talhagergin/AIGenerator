//
//  imageCartoonClient.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//

import Foundation

// MARK: - Model for the provided JSON Response

struct APIResponseModel: Decodable {
    let requestID: String
    let logID: String
    let errorCode: Int
    let errorCodeStr: String
    let errorMsg: String
    let errorDetail: ErrorDetail
    let taskType: String
    let taskID: String
    
    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case logID = "log_id"
        case errorCode = "error_code"
        case errorCodeStr = "error_code_str"
        case errorMsg = "error_msg"
        case errorDetail = "error_detail"
        case taskType = "task_type"
        case taskID = "task_id"
    }
}

struct ErrorDetail: Decodable {
    let statusCode: Int
    let code: String
    let codeMessage: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case code
        case codeMessage = "code_message"
        case message
    }
}
