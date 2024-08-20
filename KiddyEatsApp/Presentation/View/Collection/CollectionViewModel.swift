//
//  CollectionViewModel.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI
import SwiftData

class CollectionViewModel: ObservableObject {
	@Environment(\.modelContext) var modelContext
	
	@Published var searchRecipes: String = ""
	@Published var selectedView: CollectionSegment = .favoriteRecipes
	
	@Query(sort: \BabyMealSchema.name, order: .forward)
	private var meal: [BabyMealSchema]
	
	private let recipeFilteringUseCase: FilterRecipeProtocol
	
	init(recipeFilteringUseCase: FilterRecipeProtocol = FilterRecipeUseCase()) {
		self.recipeFilteringUseCase = recipeFilteringUseCase
	}
	
	var filteredRecipes: [BabyMealSchema] {
		return recipeFilteringUseCase.execute(babyMeal: [BabyMealSchema], searchQuery: searchRecipes)
	}
	
	var allergicRecipes: [BabyMealSchema] {
		filteredRecipes.filter { $0.isAllergic ?? false }
	}
}
