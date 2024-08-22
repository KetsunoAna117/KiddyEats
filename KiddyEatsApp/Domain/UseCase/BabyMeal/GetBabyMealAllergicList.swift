//
//  GetBabyMealAllergicRecipe.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation

protocol GetBabyMealAllergicListProtocol {
	func execute(babyMeal: [BabyMeal]) -> [BabyMeal]
}

struct GetBabyMealAllergicList: GetBabyMealAllergicListProtocol {
	func execute(babyMeal: [BabyMeal]) -> [BabyMeal] {
        return babyMeal.filter { $0.hasFilledReaction }
	}
}
