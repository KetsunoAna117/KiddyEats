//
//  BabyMeal.swift
//  WeaningFoodApp
//
//  Created by Arya Adyatma on 15/08/24.
//

import Foundation

struct BabyMeal: Identifiable, Codable {
    let id: UUID
    let name: String
    let emoji: String
    let ingredients: [String]
    let potentialAllergies: [String]
    let cookingSteps: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, emoji, ingredients, potentialAllergies, cookingSteps
    }
    
    init(id: UUID = UUID(), name: String, emoji: String, ingredients: [String], potentialAllergies: [String], cookingSteps: String) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.ingredients = ingredients
        self.potentialAllergies = potentialAllergies
        self.cookingSteps = cookingSteps
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        
        let emojiString = try container.decode(String.self, forKey: .emoji)
        emoji = String(emojiString.prefix(1))
        
        ingredients = try container.decode([String].self, forKey: .ingredients)
        potentialAllergies = try container.decode([String].self, forKey: .potentialAllergies)
        cookingSteps = try container.decode(String.self, forKey: .cookingSteps)
    }
}
