//
//  +BabyMeal.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation

extension BabyMeal {
    
    enum CodingKeys: String, CodingKey {
        case id, name, emoji, ingredients, allergens, cookingSteps, servingSize, estimatedCookingTimeMinutes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        
        let emojiString = try container.decode(String.self, forKey: .emoji)
        emoji = String(emojiString.prefix(1))
        
        ingredients = try container.decode([String].self, forKey: .ingredients)
        allergens = try container.decode([String].self, forKey: .allergens)
        cookingSteps = try container.decode(String.self, forKey: .cookingSteps)
        servingSize = try container.decode(Int.self, forKey: .servingSize)
        estimatedCookingTimeMinutes = try container.decode(Int.self, forKey: .estimatedCookingTimeMinutes)
		isAllergic = false
    }
    
    func isValid() -> Bool {
        return !name.isEmpty && !emoji.isEmpty && !ingredients.isEmpty && !cookingSteps.isEmpty && servingSize > 0 && estimatedCookingTimeMinutes > 0
    }
    
    static func fromIncompleteJsonList(jsonStr: String) -> [BabyMeal] {
        let decoder = JSONDecoder()
        var meals: [BabyMeal] = []
        
        let cleanedJsonStr = cleanIncompleteJson(jsonStr)
        
        if let data = cleanedJsonStr.data(using: .utf8) {
            do {
                meals = try decoder.decode([BabyMeal].self, from: data)
            } catch {
                print("Error decoding full JSON: \(error)")
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for item in jsonArray {
                        if let itemData = try? JSONSerialization.data(withJSONObject: item) {
                            do {
                                let meal = try decoder.decode(BabyMeal.self, from: itemData)
                                meals.append(meal)
                            } catch {
                                print("Error decoding individual item: \(error)")
                            }
                        }
                    }
                }
            }
        }
        
        return meals.filter { $0.isValid() }
    }
    
    static func cleanIncompleteJson(_ jsonStr: String) -> String {
        var cleanedStr = jsonStr
        
        // Remove any incomplete object at the end
        if let lastBraceIndex = cleanedStr.lastIndex(of: "}") {
            cleanedStr = String(cleanedStr[...lastBraceIndex])
        }
        
        // Ensure the JSON array is properly closed
        cleanedStr = cleanedStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanedStr.hasSuffix("]") {
            cleanedStr += "]"
        }
        
        // Replace any null values with empty strings or arrays
        cleanedStr = cleanedStr.replacingOccurrences(of: ": null", with: ": \"\"")
        cleanedStr = cleanedStr.replacingOccurrences(of: ": []", with: ": []")
        
        return cleanedStr
    }
    
    static func testIncompleteJson() -> String {
        let jsonStr = """
        [
        {
        "id": "7b507a36-bf8a-4f05-a646-99de3b638bc3",
        "name": "Chicken and Vegetable Puree",
        "emoji": "🍗",
        "ingredients": [
        "100 grams chicken breast, chopped",
        "50 grams carrot, chopped",
        "50 grams potato, chopped",
        "200 ml water"
        ],
        "allergens": [
        "Eggs",
        "Peanuts"
        ],
        "cookingSteps": "Serving Size: 1\\n1. In a saucepan, combine chicken, carrot, and potato. \\n2. Add water and bring to a boil. \\n3. Reduce heat and simmer for 20 minutes or until the vegetables are soft. \\n4. Blend the mixture until smooth. \\n5. Allow to cool before serving.",
        "servingSize": 1,
        "estimatedCookingTimeMinutes": 30
        },
        {
        "id": "cbb565f6-0a74-4124-8b5b-44e5b6b8e09a",
        "name": "Chicken
        """
        
        let meals = fromIncompleteJsonList(jsonStr: jsonStr)
        
        var result = "Successfully parsed \(meals.count) meal(s):\n\n"
        for (index, meal) in meals.enumerated() {
            result += "Meal \(index + 1):\n"
            result += "Name: \(meal.name)\n"
            result += "Emoji: \(meal.emoji)\n"
            result += "Ingredients: \(meal.ingredients.joined(separator: ", "))\n"
            result += "Allergens: \(meal.allergens.joined(separator: ", "))\n"
            result += "Cooking Steps: \(meal.cookingSteps)\n"
            result += "Serving Size: \(meal.servingSize)\n"
            result += "Estimated Cooking Time: \(meal.estimatedCookingTimeMinutes) minutes\n\n"
        }
        
        return result
    }
    
    
}
