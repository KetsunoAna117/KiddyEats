//
//  BabyMealRecommenderUseCase.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import Foundation

class BabyMealRecommenderUseCase {
    typealias MealRecommendationCallback = (String) -> Void
    
    // NOTE: Nanti ini bakal sesuai profile bayi
    let fakeBaby = BabyProfile(
        name: "Nathan",
        gender: "Male",
        allergies: ["Eggs", "Peanuts"],
        dateOfBirth: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
        location: "Indonesia"
    )
    
    private let aiService: AIService
    
    private let commonFoodAllergies = "Milk, Egg, Fish, Crustacean shellfish, Tree nuts, Peanuts, Wheat, Soybeans, Sesame"
    
    private let jsonSchema = """
    {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "BabyMeal",
    "type": "object",
    "properties": {
    "id": {
    "type": "string",
    "format": "uuid",
    "description": "Unique identifier for the meal"
    },
    "name": {
    "type": "string",
    "description": "Name of the meal"
    },
    "emoji": {
    "type": "string",
    "description": "Emoji representing the meal, one character. You can't use same emoji in same generation batch."
    },
    "ingredients": {
    "type": "array",
    "items": {
    "type": "string"
    },
    "description": "List of ingredients for the meal, include units separated by comma"
    },
    "allergens": {
    "type": "array",
    "items": {
    "type": "string"
    },
    "description": "List of potential allergies, each allergy must 1-2 words in title case."
    },
    "cookingSteps": {
    "type": "string",
    "description": "Steps to cook the meal in numbered list and newline."
    },
    "servingSize": {
    "type": "integer",
    "description": "Number of servings the meal provides"
    },
    "estimatedCookingTimeMinutes": {
    "type": "integer",
    "description": "Estimated cooking time in minutes"
    }
    },
    "required": ["id", "name", "emoji", "ingredients", "allergens", "cookingSteps", "servingSize", "estimatedCookingTimeMinutes"]
    }
    """
    
    private let rules = """
    Rules:
    - Your returned ingredients must include units such as grams, tablespoons, teaspoon,
    - Don't forget to include potentialAllergies in your recommended foods if exists based on common food allergies or any other allergies.
    - Before the cooking guidelines, include "Serving Size: X" the number of serving size.
    - The cooking guidelines must step by step in numbered list using newline.
    - The emoji is only one character.
    - Wrap your response with JSON array.
    
    NEVER wrap your response data with triple backticks, just answer straight to the plain text json!
    
    TESTING = TRUE
    - For this time, you need to generate foods that have allergens. Include minimum 1 allergens.
    """
    
    init() {
        self.aiService = AIService(identifier: FakeAPIKey.GPT4o.rawValue, isConversation: false)
    }
    
    func recommendMeals(profile: BabyProfile, searchQuery: String? = nil) async -> [BabyMeal] {
        let llmPrompt = constructLLMPrompt(profile: profile, searchQuery: searchQuery)
        print(llmPrompt)
        
        let response = aiService.sendMessage(query: llmPrompt, uiImage: nil)
        return decodeMeals(from: response)
    }
    
    func recommendMealsStreaming(profile: BabyProfile, searchQuery: String? = nil, onToken: @escaping MealRecommendationCallback) async throws {
        let llmPrompt = constructLLMPrompt(profile: profile, searchQuery: searchQuery)
        print(llmPrompt)
        
        try await aiService.sendMessageStreaming(query: llmPrompt, uiImage: nil, onToken: onToken)
    }
    
    private func constructLLMPrompt(profile: BabyProfile, searchQuery: String?) -> String {
        var prompt = """
        You are an expert in child healthcare.
        
        Your job is to recommend baby meals based on baby profile.
        
        External Info - Common Food Allergies based on FDA:
        \(commonFoodAllergies)
        
        Use this JSON schema on your response:
        ```
        \(jsonSchema)
        ```
        
        \(rules)
        
        ---
        
        Please recommend 6 baby meals based on this baby profile:
        \(generateBabyProfileString(profile))
        """
        
        if let searchQuery = searchQuery {
            prompt += "\n\nAlso use this search query: \(searchQuery).\n\nIf the search query is nonsense, just return a random meal based on baby profile, always follow the schema!"
        }
        
        return prompt
    }
    
    private func generateBabyProfileString(_ profile: BabyProfile) -> String {
        """
        Name: \(profile.name)
        Gender: \(profile.gender)
        Age: \(profile.ageMonths) months
        Location: \(profile.location)
        Allergies: [\(profile.allergies.joined(separator: ", "))]
        """
    }
    
    private func decodeMeals(from response: String) -> [BabyMeal] {
        let jsonData = Data(response.utf8)
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode([BabyMeal].self, from: jsonData)
        } catch {
            print("Error decoding meals: \(error.localizedDescription)")
            return []
        }
    }
}
