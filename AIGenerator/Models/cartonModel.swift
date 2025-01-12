//
//  cartoon.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//

import Foundation

struct APICartonResponseModel: Decodable {
    let data: TaskData
    let error_code: Int
    let error_detail: ErrorDetail
    let log_id: String
    let request_id: String
    let task_id: String
    let task_type: String
    
     struct TaskData: Decodable {
         let status: String
    }

    struct ErrorDetail: Decodable {
        let status_code: Int
        let code: String
        let code_message: String
        let message: String
    }
}

struct cartonModel: Decodable {
    let data: CartoonData?
    let error_code: Int
    let error_detail: ErrorDetail
    let log_id: String
    let request_id: String
    let task_status: Int

    struct CartoonData: Decodable {
        let status: String
        let result_url: String?
    }

    struct ErrorDetail: Decodable {
        let status_code: Int
        let code: String
        let code_message: String
        let message: String
    }
}
