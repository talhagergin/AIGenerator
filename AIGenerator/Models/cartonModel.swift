//
//  cartoon.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//

import Foundation

struct cartonModel: Decodable {
    let data: TaskData?
    let errorCode: Int
    let errorDetail: ErrorDetail
    let logID: String
    let requestID: String
    let taskStatus: Int

    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case errorDetail = "error_detail"
        case logID = "log_id"
        case requestID = "request_id"
        case taskStatus = "task_status"
    }
}

struct TaskData: Decodable {
    let status: String
    let resultURL: String

    enum CodingKeys: String, CodingKey {
        case status
        case resultURL = "result_url"
    }
}
