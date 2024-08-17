//
//  BabyMeal.swift
//  WeaningFoodApp
//
//  Created by Arya Adyatma on 15/08/24.
//

import Foundation
import SwiftUI

struct BabyMeal: Identifiable, Codable {
    var id: UUID
    var name: String
    var emoji: String
    var ingredients: [String]
    var allergens: [String]
    var cookingSteps: String
    var servingSize: Int
    var estimatedCookingTimeMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, emoji, ingredients, allergens, cookingSteps, servingSize, estimatedCookingTimeMinutes
    }
    
    init(id: UUID = UUID(), name: String, emoji: String, ingredients: [String], allergens: [String], cookingSteps: String, servingSize: Int, estimatedCookingTimeMinutes: Int) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.ingredients = ingredients
        self.allergens = allergens
        self.cookingSteps = cookingSteps
        self.servingSize = servingSize
        self.estimatedCookingTimeMinutes = estimatedCookingTimeMinutes
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
    }
    
    func isValid() -> Bool {
        return !name.isEmpty && !emoji.isEmpty && !ingredients.isEmpty && !cookingSteps.isEmpty && servingSize > 0 && estimatedCookingTimeMinutes > 0
    }
}



// For testing only

struct BabyMealTestView: View {
    @State private var resultText: String = ""
    
    var body: some View {
        ScrollView {
            Text(resultText)
                .padding()
        }
        .onAppear {
            resultText = BabyMeal.testIncompleteJson()
        }
    }
}

#Preview {
    BabyMealTestView()
}
