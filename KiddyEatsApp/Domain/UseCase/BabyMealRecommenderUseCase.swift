//
//  BabyMealRecommenderUseCase.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import Foundation

class BabyMealRecommenderUseCase {
    let aiService: AIService

    init() {
        self.aiService = AIService(identifier: AIServiceKeys.generalLLM.rawValue, isConversation: false)
    }
    
    func recommendMeals(profile: BabyProfile, searchQuery: String? = nil) async -> [BabyMeal] {
        let llmPrompt = constructLLMPrompt(profile: profile, searchQuery: searchQuery)
        
        let response = aiService.sendMessage(query: llmPrompt, uiImage: nil)
        return decodeMeals(from: response)
    }
    
    func recommendMealsStreaming(profile: BabyProfile, searchQuery: String? = nil, onToken: @escaping MealRecommendationCallback) async throws {
        let llmPrompt = constructLLMPrompt(profile: profile, searchQuery: searchQuery)
        
        try await aiService.sendMessageStreaming(query: llmPrompt, uiImage: nil, onToken: onToken)
    }

}
