//
//  LLMBlockingResponse.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//


struct LLMBlockingResponse: Decodable {
    let event: String
    let message_id: String?
    let conversation_id: String?
    let answer: String?
    let created_at: Int?
}
