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
	
	@Query(sort: \DummyRecipeModel.dummyName, order: .forward)
	private var dummies: [DummyRecipeModel]
	
	@State
	private var searchRecipes: String = ""
	@State
	private var selectedView: CollectionSegment = .favoriteRecipes
	
	var filteredRecipes: [DummyRecipeModel] {
		if searchRecipes.isEmpty {
			return dummies
		}
		
		let filteredRecipes = dummies.compactMap { dummy in
			let recipeContainsQuery = dummy.dummyName.range(of: searchRecipes, options: .caseInsensitive) != nil
			
			return recipeContainsQuery ? dummy : nil
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
						let dummyFavorite = filteredRecipes.filter { $0.dummyIsLiked }
						
						if dummyFavorite.isEmpty {
							ContentUnavailableView {
								Label("No Favorite Recipe", systemImage: "heart.slash.fill")
							} description: {
								Text("Your favorite recipes will appear here.")
							}
						} else {
							CollectionRecipeView(dummyFavorite: dummyFavorite)
						}
					case .allergicRecipes:
						let dummyAllergic = filteredRecipes.filter { $0.dummyIsAllergic }
						
						if dummyAllergic.isEmpty {
							ContentUnavailableView {
								Label("No Allergy-Inducing Recipe", systemImage: "exclamationmark.triangle.fill")
							} description: {
								Text("Recipes that can cause allergic reaction will appear here.")
							}
						} else {
							CollectionRecipeView(dummyFavorite: dummyAllergic)
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
