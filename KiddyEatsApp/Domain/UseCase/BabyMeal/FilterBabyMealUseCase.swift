//
//  RecipeFiltering.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation

protocol FilterBabyMealProtocol {
	func execute(babyMeal: [BabyMeal], searchQuery: String) -> [BabyMeal]
}

struct FilterBabyMealUseCase: FilterBabyMealProtocol {
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
