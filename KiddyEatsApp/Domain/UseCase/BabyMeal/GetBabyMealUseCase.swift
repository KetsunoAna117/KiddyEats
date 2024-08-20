//
//  RecipeFiltering.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation

protocol GetBabyMealProtocol {
	func execute(babyMeal: [BabyMeal], searchQuery: String) -> [BabyMeal]
}

struct FilterBabyMealUseCase: GetBabyMealProtocol {
	func execute(babyMeal: [BabyMeal], searchQuery: String) -> [BabyMeal] {
		if searchQuery.isEmpty {
			return babyMeal
		}
		
		return babyMeal.compactMap { meal in
			let recipeContainsQuery = meal.name.range(of: searchQuery, options: .caseInsensitive) != nil
			return recipeContainsQuery ? meal : nil
		}
	}
}
