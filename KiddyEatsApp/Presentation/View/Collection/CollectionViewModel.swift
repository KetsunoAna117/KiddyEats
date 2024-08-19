//
//  CollectionViewModel.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI
import SwiftData

class CollectionViewModel: ObservableObject {
	@Environment(\.modelContext)
	var modelContext
	
	@Query(sort: \DummyRecipeModel.dummyName, order: .forward)
	private var dummies: [DummyRecipeModel]
	
	@Published
	var searchRecipes: String = ""
	
	@Published
	var selectedView: CollectionSegment = .favoriteRecipes
	
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
	
	var favoriteRecipes: [DummyRecipeModel] {
		filteredRecipes.filter { $0.dummyIsLiked }
	}
	
	var allergicRecipes: [DummyRecipeModel] {
		filteredRecipes.filter { $0.dummyIsAllergic }
	}
}
