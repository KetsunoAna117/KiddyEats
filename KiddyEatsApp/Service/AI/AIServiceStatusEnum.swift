//
//  AIStatusEnum.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

enum AIServiceStatusEnum: String {
    case idle = "Idle"
    case compressingImage = "Compressing Image"
    case uploadingImage = "Uploading Image"
    case processingImage = "Processing Image"
    case preparingQuery = "Preparing Query"
    case gettingResponse = "Getting Response from AI"
    case processingResponse = "Processing AI Response"
    case error = "Error Occurred"
}
