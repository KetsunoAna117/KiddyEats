//
//  BabyMealSchema.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

@Model
final class BabyMealSchema {
    @Attribute(.unique) var id: UUID
    var name: String?
    var emoji: String?
    var ingredients: [String]?
    var allergens: [String]?
    var cookingSteps: String?
    var servingSize: Int?
    var estimatedCookingTimeMinutes: Int?
	var isAllergic: Bool?
    var hasFilledReaction: Bool?
    var reactionList: [String]
    
    init(id: UUID, name: String, emoji: String, ingredients: [String], allergens: [String], cookingSteps: String, servingSize: Int, estimatedCookingTimeMinutes: Int, isAllergic: Bool, hasFilledReaction: Bool, reactionList: [String]) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.ingredients = ingredients
        self.allergens = allergens
        self.cookingSteps = cookingSteps
        self.servingSize = servingSize
        self.estimatedCookingTimeMinutes = estimatedCookingTimeMinutes
		self.isAllergic = isAllergic
        self.hasFilledReaction = hasFilledReaction
        self.reactionList = reactionList
    }
    
    func mapToBabyMeal() -> BabyMeal {
        return BabyMeal(
            id: self.id,
            name: self.name ?? "",
            emoji: self.emoji ?? "",
            ingredients: self.ingredients ?? [],
            allergens: self.allergens ?? [],
            cookingSteps: self.cookingSteps ?? "",
            servingSize: self.servingSize ?? -1,
			estimatedCookingTimeMinutes: self.estimatedCookingTimeMinutes ?? -1,
			isAllergic: false,
            hasFilledReaction: self.hasFilledReaction ?? false,
            reactionList: self.reactionList
        )
    }
}
