//
//  +BabyMealRecommenderUseCase.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation

extension BabyMealRecommenderUseCase {
    typealias MealRecommendationCallback = (String) -> Void
    
    // NOTE: Nanti ini bakal sesuai profile bayi
    var fakeBaby: BabyProfile {
        BabyProfile(
            id: UUID(),
            name: "Nathan",
            gender: "Male",
            allergies: ["Eggs", "Peanuts"],
            dateOfBirth: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
            location: "Indonesia"
        )
    }
    
    internal func constructLLMPrompt(profile: BabyProfile, searchQuery: String? = nil) -> String {
        var searchPrompt: String = ""
        
        if let searchQuery = searchQuery {
            searchPrompt = "Search Query:\"\(searchQuery)\""
        }
        
        var prompt = """
        You are an expert in child healthcare. Your job is to recommend baby meals based on baby profile.
        
        External Info - Common Food Allergies based on FDA:
        \(commonFoodAllergies)
        
        Use this JSON schema on your response:
        ```
        \(jsonSchema)
        ```
        
        \(rules)
        
        ---
        
        \(searchPrompt)
        
        Please recommend 6 baby meals based on this baby profile (avoid recommending foods that contain allergens in the baby profile):
        \(generateBabyProfileString(profile))
        """
                
        return prompt
    }
    
    internal func generateBabyProfileString(_ profile: BabyProfile) -> String {
        """
        Name: \(profile.name)
        Gender: \(profile.gender)
        Age: \(profile.ageMonths) months
        Location: \(profile.location)
        Allergies: [\(profile.allergies.joined(separator: ", "))]
        """
    }
    
    internal var commonFoodAllergies: String  {
        "Milk, Egg, Fish, Crustacean shellfish, Tree nuts, Peanuts, Wheat, Soybeans, Sesame"
    }
    
    internal var rules: String {
    """
    RESPONSE RULES:
    - Your returned ingredients must include units such as grams, tablespoons, teaspoon.
    - Don't forget to include meal allergens in your recommended foods if there.
    - The cooking guidelines must step by step in numbered list using newline.
    - The emoji is only one character, and you MUST include emoji to every meal.
    - You must always response with JSON based on the schema, regardless anything the user query.
    - Wrap your response with JSON array "[]".
    - If there is a search query, please recommend meals related on search query but the meals still need to adjust to baby profile. The first 4 meals must related to search query. If the search query is typo or nonsense, just return the closest meal to the search query based on baby profile. The last 2 meals don't need to include the query.
    - For the last meal, you MUST recommend any meal that contain any allergen for testing purposes. That allergen must not the allergen that in Baby Profile!
    
    IMPORTANT: NEVER EVER wrap your response data with triple backticks, just answer straight to the plain text json!
    """
    }

    internal var jsonSchema: String  {
    """
    {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "BabyMeal",
    "type": "object",
    "properties": {
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
    "description": "List of food allergens, each allergen must 1-2 words in title case. If there are no allergens, just leave this array empty."
    },
    "cookingSteps": {
    "type": "string",
    "description": "Steps to cook the meal in numbered list and newline. Make it as simple as possible."
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
    "required": ["name", "emoji", "ingredients", "allergens", "cookingSteps", "servingSize", "estimatedCookingTimeMinutes"]
    }
    """
    }
    
    internal func decodeMeals(from response: String) -> [BabyMeal] {
        let jsonData = Data(response.utf8)
        
        do {
            return try JSONDecoder().decode([BabyMeal].self, from: jsonData)
        } catch {
            print("Error decoding meals: \(error.localizedDescription)")
            return []
        }
    }

}
