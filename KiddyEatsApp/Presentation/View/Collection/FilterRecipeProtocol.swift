//
//  RecipeFiltering.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation

protocol FilterRecipeProtocol {
	func execute(babyMeal: [BabyMealSchema], searchQuery: String) -> [BabyMealSchema]
}

struct FilterRecipeUseCase: FilterRecipeProtocol {
	func execute(babyMeal: [BabyMealSchema], searchQuery: String) -> [BabyMealSchema] {
		if searchQuery.isEmpty {
			return babyMeal
		}
		
		return babyMeal.compactMap { meal in
			let recipeContainsQuery = meal.name?.range(of: searchQuery, options: .caseInsensitive) != nil
			return recipeContainsQuery ? meal : nil
		}
	}
}
