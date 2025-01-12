//
//  APIEndpoint.swift
//  AIGenerator
//
//  Created by Talha Gergin on 12.01.2025.
//

import Foundation
enum APIEndpoint{
    static let postHeaders = [
        "x-apihub-key": "GmRLvb4sU8w9Xv99zr3bi0krj9ilERgTtGQ9IrKRXld1XrTnxR",
        "x-apihub-host": "AI-Cartoon-Generator.allthingsdev.co",
        "x-apihub-endpoint": "b8d9da51-8404-4936-bd3d-f4a91fe232ae"
    ]
    static let getHeaders = [
        "x-apihub-key": "GmRLvb4sU8w9Xv99zr3bi0krj9ilERgTtGQ9IrKRXld1XrTnxR",
        "x-apihub-host": "AI-Cartoon-Generator.allthingsdev.co",
        "x-apihub-endpoint": "679a2896-4f0e-49f3-80ba-ef5443ec6261"
    ]
    static let baseURL = "https://AI-Cartoon-Generator.proxy-production.allthingsdev.co/image/effects/generate_cartoonized_image"
    static let getCartonURL = "https://AI-Cartoon-Generator.proxy-production.allthingsdev.co/api/allthingsdev/query-async-task-result?task_id="
   
}
