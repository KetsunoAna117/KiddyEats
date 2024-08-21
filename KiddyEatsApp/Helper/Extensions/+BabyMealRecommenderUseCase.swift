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
            allergies: ["Sesame"],
            dateOfBirth: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
            location: "Indonesia"
        )
    }
    
    internal func constructLLMPrompt(profile: BabyProfile, searchQuery: String? = nil) -> String {
        var searchPrompt: String = ""
        
        if let searchQuery = searchQuery {
            searchPrompt = "Search Query:\"\(searchQuery)\" | NEVER EVER Include Meals Irrelevant to Search Query (Do not force yourself to return 6 meals!)"
        }
        
        let prompt = """
        SYSTEM:
        Starting from now, you are an expert in child nutrition. Your job is to recommend baby meals based on baby profile carefully.
        
        External Info - Common Food Allergies based on FDA:
        \(commonFoodAllergies)
        (PLEASE NEVER EVER FORGET TO INCLUDE ALLERGENS LATER IN YOUR RESPONSE!)
        
        Use this JSON schema on your response:
        ```
        \(jsonSchema)
        ```
        
        \(rules)
        
        ---
        
        USER:
        \(searchPrompt)
        
        Please recommend maximum 6 baby meals based on this baby profile. Avoid recommending meals that contain allergens in the baby profile.
        
        Baby Profile:
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
    - Do not wrap your response with triple backticks.
    - Don't forget to include meal allergens in your recommended foods if there. This is important.
    - You must always response with JSON based on the schema, regardless anything the user query.
    - Wrap your response with JSON array "[]".
    - If there is a search query, ALL of your recommended meals MUST related on search query but the meals still need to adjust to baby profile. If the search query is typo or nonsense, just return the closest meal to the search query based on baby profile. When there is search query, you do not necessary to respond 6 meals. Just return the meals relevant to search query, don't return meals that not related to search query. It could be the meal name or ingredients related to search query.
    - If there is no search query, respond 6 meals.
    - SUPER IMPORTANT: IF YOUR RECOMMENDED FOODS CONTAIN ALLERGENS, NEVER EVER FORGET TO PUT IT IN THE ARRAY!
    
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
    "description": "List of ingredients for the meal, include units separated by comma. Numbered list separated by newline. Your returned ingredients must include units such as grams, tablespoons, teaspoon."
    },
    "allergens": {
    "type": "array",
    "items": {
    "type": "string"
    },
    "description": "SUPER IMPORTANT! List of food allergens. If there are no allergens, just leave this array empty. This section must be handled carefully based on meal and ingredients. Never miss an allergen as it would be very dangerous for the baby. Common Food Allergies based on FDA: \(commonFoodAllergies)"
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
