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
	
	@State
	var viewModel = BabyMealListViewModel(
		getBabyMealListUseCase: GetBabyMealListUseCase(repo: BabyMealRepositoryImpl.shared),
		getFilterBabyMeal: FilterBabyMealUseCase(),
		getBabyMealAllergicList: GetBabyMealAllergicList(),
		deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared)
	)
	
    var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				// Segmented Control
				Picker("Select a view", selection: $viewModel.selectedView) {
					Text("Favorite Recipes").tag(CollectionSegment.favoriteRecipes)
					Text("Causing Allergy").tag(CollectionSegment.allergicRecipes)
				}
				.pickerStyle(.segmented)
				.padding()
				
				// Switch between views
				switch viewModel.selectedView {
					case .favoriteRecipes:
						if viewModel.showedMealList.isEmpty {
							ContentUnavailableView {
								Label("No Favorite Recipe", systemImage: "heart.slash.fill")
							} description: {
								Text("Your favorite recipes will appear here.")
							}
						} else {
							CollectionRecipeView(babyMeal: $viewModel.showedMealList, viewModel: viewModel)
						}
					case .allergicRecipes:
						let mealAllergic = viewModel.showedMealList
						
						if mealAllergic.isEmpty {
							ContentUnavailableView {
								Label("No Allergy-Inducing Recipe", systemImage: "exclamationmark.triangle.fill")
							} description: {
								Text("Recipes that can cause allergic reaction will appear here.")
							}
						} else {
							CollectionRecipeView(babyMeal: $viewModel.showedMealList, viewModel: viewModel)
						}
				}
			}
			.navigationTitle("Your Saved Recipes")
			.searchable(text: $viewModel.searchRecipe, prompt: "Search your saved recipes")
			.onAppear {
				viewModel.initAllMealList(modelContext: modelContext)
			}
			.onChange(of: viewModel.selectedView) { oldValue, newValue in
				switch newValue {
					case .favoriteRecipes:
						viewModel.setFavoriteList()
					case .allergicRecipes:
						viewModel.getMealAllergic(modelContext: modelContext)
				}
			}
		}
    }
}

#Preview {
    CollectionView()
}
