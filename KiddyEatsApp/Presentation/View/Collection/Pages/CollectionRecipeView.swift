//
//  CollectionFavoriteView.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI

struct CollectionRecipeView: View {
	@Binding
	var babyMeal: [BabyMeal]
	
	@Bindable
	var viewModel: BabyMealListViewModel
	
    var body: some View {
		List {
			ForEach(babyMeal) { meals in
				#warning("Wrap UIViewController with UIViewControllerRepresentable and put representable here in destination")
				NavigationLink(destination: TestMealDetailUIViewControllerRepresentable()) {
					RecipeRowView(viewModel: viewModel, mealRecipe: meals)
				}
			}
			.listRowSeparator(.hidden)
			.listRowBackground(
				Color.exploreCardBackground
			)
		}
		.listRowSpacing(10)
		.scrollContentBackground(.hidden)
		.padding(.top, -20)
    }
}
