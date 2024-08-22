//
//  RecipeListView.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI
import SwiftData

struct RecipeRowView: View {
	@Environment(\.modelContext)
	var modelContext
	
	@Bindable
	var viewModel: BabyMealListViewModel
	var mealRecipe: BabyMeal
	
    var body: some View {
		HStack {
			Text(mealRecipe.emoji)
				.font(.system(size: 40))
				.padding(.trailing)
			
			VStack(alignment: .leading) {
				Text(mealRecipe.name)
					.font(.headline)
					.padding(.bottom, 2)
				
				HStack {
					Image(systemName: "takeoutbag.and.cup.and.straw")
					Text("\(mealRecipe.ingredients[0])")
				}
				.font(.callout)

				HStack {
					Image(systemName: "clock.arrow.circlepath")
					Text("\(mealRecipe.estimatedCookingTimeMinutes) minutes")
				}
				.font(.callout)
			}
			
			Spacer()
			
            if mealRecipe.hasFilledReaction {
				Image(systemName: "exclamationmark.triangle")
					.symbolVariant(.fill)
					.font(.largeTitle)
					.foregroundStyle(Color.greenPrimary)
			}
		}
		.swipeActions {
			Button(role: .destructive) {
				withAnimation {
					viewModel.deleteBabyMeal(modelContext: modelContext, toDeleteBabyMeal: mealRecipe)
                    viewModel.initAllMealList(modelContext: modelContext)
				}
				
			} label: {
				Label("Delete", systemImage: "trash")
					.symbolVariant( .fill)
			}
		}
    }
}
