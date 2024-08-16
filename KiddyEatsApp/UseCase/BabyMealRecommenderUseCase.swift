//
//  BabyMealRecommenderUseCase.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import Foundation

class BabyMealRecommenderUseCase {
    let aiService: AIService = AIService(identifier: FakeAPIKey.GPT4o.rawValue, isConversation: false)
    
    let fakeBaby = BabyProfile(
        name: "Nathan",
        gender: "Male",
        allergies: ["Eggs", "Peanuts"],
        dateOfBirth: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
        location: "Indonesia"
    )
    
    let fakeMeals = [
        BabyMeal(name: "Mashed Banana", emoji: "🍌", ingredients: ["banana"], allergens: [], cookingSteps: "Mash the banana until smooth.", servingSize: 1, estimatedCookingTimeMinutes: 5),
        BabyMeal(name: "Pureed Carrots", emoji: "🥕", ingredients: ["carrot"], allergens: [], cookingSteps: "Steam the carrots and puree until smooth.", servingSize: 1, estimatedCookingTimeMinutes: 15),
        BabyMeal(name: "Apple Sauce", emoji: "🍏", ingredients: ["apple"], allergens: [], cookingSteps: "Peel, core, and cook the apples until soft, then puree until smooth.", servingSize: 2, estimatedCookingTimeMinutes: 20)
    ]
    
    func recommendMeals(profile: BabyProfile, searchQuery: String? = nil) async -> [BabyMeal] {
        let babyProfileString = """
        Name: \(profile.name)
        Gender: \(profile.gender)
        Age: \(profile.ageMonths) months
        Location: \(profile.location)
        Allergies: [\(profile.allergies.joined(separator: ", "))]
        """
        
        //        let commonFoodAllergies = "Peanuts, Tree nuts, Milk, Eggs, Soy, Wheat, Fish, Shellfish, Sesame, Corn, Celery, Mustard, Lupin, Sulfites, Gluten, Kiwi, Strawberries, Peaches, Avocado, Banana"
        let commonFoodAllergies = "Milk, Egg, Fish, Crustacean shellfish, Tree nuts, Peanuts, Wheat, Soybeans, Sesame"
        
        var llmPrompt = """
        You are an expert in child healthcare.
        
        Your job is to recommend baby meals based on baby profile.
        
        External Info - Common Food Allergies based on FDA:
        \(commonFoodAllergies)
        
        Use this JSON schema on your response:
        ```
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
        ```
        
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
        
        ---
        
        Please recommend 6 baby meals based on this baby profile:
        \(babyProfileString)
        """
        
        if searchQuery != nil {
            llmPrompt += "\n\nAlso use this search query: \(searchQuery!).\n\nIf the search query is nonsense, just return a random meal based on baby profile, always follow the schema!"
        }
        
        print(llmPrompt)
        // Implement LLM API call and parse response
        let response = aiService.sendMessage(query: llmPrompt, uiImage: nil)
        
        // Convert response to list of meals
        let jsonData = Data(response.utf8)
        let decoder = JSONDecoder()
        
        do {
            let meals = try decoder.decode([BabyMeal].self, from: jsonData)
            return meals
        } catch DecodingError.dataCorrupted(let context) {
            print("Data corrupted: \(context.debugDescription)")
            return fakeMeals
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
            return fakeMeals
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch: \(context.debugDescription)")
            return fakeMeals
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Value of type '\(type)' not found: \(context.debugDescription)")
            return fakeMeals
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            return fakeMeals
        }
    }
}
