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
	
	let dummyRecipe: DummyRecipeModel
	
    var body: some View {
		HStack {
			Text(dummyRecipe.dummyEmoji)
				.font(.system(size: 40))
				.padding(.trailing)
			
			VStack(alignment: .leading) {
				Text(dummyRecipe.dummyName)
					.font(.title2)
					.padding(.bottom, 2)
				Text("Cooking time: ")
					.font(.caption)
				Text("Difficulty: ")
					.font(.caption)
			}
			
			Spacer()
			
			if dummyRecipe.dummyIsAllergic {
				Image(systemName: "exclamationmark.triangle")
					.symbolVariant(.fill)
					.font(.largeTitle)
					.foregroundStyle(Color.red)
			}
		}
		.swipeActions {
			Button(role: .destructive) {
				withAnimation {
					modelContext.delete(dummyRecipe)
				}
				
			} label: {
				Label("Delete", systemImage: "trash")
					.symbolVariant( .fill)
			}
		}
    }
}
