//
//  BabyMealRecommenderUseCase.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import Foundation

class BabyMealRecommenderUseCase {
    var aiService: AIService

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

    func analyzeAllergicIngredients(profile: BabyProfile, meal: BabyMeal) -> [String] {
        let prompt = """
        SYSTEM:
        
        Starting from now, you are an expert in child nutritionist.
        Your job is to extract allergens from provided Baby Profile, Baby Meal, and the baby's reaction after consuming that meal.
        
        You must return an array of JSON string, without triple backticks.
        
        Example Interaction:
        ```
        USER: (Provides baby profile, baby meal, and reaction after eating meal)
        ASSISTANT: ["Wheat", "Soy"]
        ```
        
        Now you are connected to user. Please do this job carefully.
        
        ---
        
        USER: Please give me the list of potential allergens in JSON. Do not wrap your response with triple backticks.
        
        Baby Profile:
        \(generateBabyProfileString(profile))
        
        Baby Meal:
        \(meal.toString())
        """
        
        let response = aiService.sendMessage(query: prompt, uiImage: nil)
        
        do {
            let allergens = try JSONDecoder().decode([String].self, from: response.data(using: .utf8) ?? Data())
            return allergens
        } catch {
            print("Error decoding allergens: \(error)")
            return []
        }
    }
}
