//
//  CollectionView.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
	@Environment(\.modelContext)
	var modelContext
	
	@Query(sort: \BabyMealSchema.name, order: .forward)
	private var babyMeal: [BabyMealSchema]
	
	@State
	private var searchRecipes: String = ""
	@State
	private var selectedView: CollectionSegment = .favoriteRecipes
	
	var filteredRecipes: [BabyMealSchema] {
		if searchRecipes.isEmpty {
			return babyMeal
		}
		
		let filteredRecipes = babyMeal.compactMap { meal in
			let recipeContainsQuery = meal.name?.range(of: searchRecipes, options: .caseInsensitive) != nil
			
			return recipeContainsQuery ? meal : nil
		}
		
		return filteredRecipes
	}
	
    var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				// Segmented Control
				Picker("Select a view", selection: $selectedView) {
					Text("Favorite Recipes").tag(CollectionSegment.favoriteRecipes)
					Text("Causing Allergy").tag(CollectionSegment.allergicRecipes)
				}
				.pickerStyle(.segmented)
				.padding()
				
				// Switch between views
				switch selectedView {
					case .favoriteRecipes:
						if babyMeal.isEmpty {
							ContentUnavailableView {
								Label("No Favorite Recipe", systemImage: "heart.slash.fill")
							} description: {
								Text("Your favorite recipes will appear here.")
							}
						} else {
							CollectionRecipeView(babyMeal: babyMeal)
						}
					case .allergicRecipes:
						let mealAllergic = filteredRecipes.filter { $0.isAllergic }
						
						if mealAllergic.isEmpty {
							ContentUnavailableView {
								Label("No Allergy-Inducing Recipe", systemImage: "exclamationmark.triangle.fill")
							} description: {
								Text("Recipes that can cause allergic reaction will appear here.")
							}
						} else {
							CollectionRecipeView(dummyFavorite: mealAllergic)
						}
				}
			}
			.navigationTitle("Your Saved Recipes")
			.searchable(text: $searchRecipes, prompt: "Search your saved recipes")
		}
    }
}

#Preview {
    CollectionView()
}
