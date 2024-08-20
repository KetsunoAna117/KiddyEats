//
//  RecipeListView.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
	@Environment(\.modelContext)
	var modelContext
	
	let mealRecipe: BabyMealSchema
	
    var body: some View {
		HStack {
			Text(mealRecipe.emoji!)
				.font(.system(size: 40))
				.padding(.trailing)
			
			VStack(alignment: .leading) {
				Text(mealRecipe.name!)
					.font(.title2)
					.padding(.bottom, 2)
				Text("Cooking time: \(mealRecipe.estimatedCookingTimeMinutes)")
					.font(.caption)
				Text("Difficulty: ")
					.font(.caption)
			}
			
			Spacer()
			
			if mealRecipe.isAllergic! {
				Image(systemName: "exclamationmark.triangle")
					.symbolVariant(.fill)
					.font(.largeTitle)
					.foregroundStyle(Color.red)
			}
		}
		.swipeActions {
			Button(role: .destructive) {
				withAnimation {
					modelContext.delete(mealRecipe)
				}
				
			} label: {
				Label("Delete", systemImage: "trash")
					.symbolVariant( .fill)
			}
		}
    }
}
