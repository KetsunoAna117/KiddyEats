//
//  CollectionFavoriteView.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 19/08/24.
//

import SwiftUI

struct CollectionRecipeView: View {
	var dummyFavorite: [DummyRecipeModel]
	
    var body: some View {
		List {
			ForEach(dummyFavorite) { dummy in
				NavigationLink {
					// TODO: Change the destination to recipe detail page
					EmptyView()
				} label: {
					RecipeListView(dummyRecipe: dummy)
				}
			}
			.listRowSeparator(.hidden)
			.listRowBackground(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.gray, lineWidth: 0.5)
			)
		}
		.listRowSpacing(10)
		.scrollContentBackground(.hidden)
		.padding(.top, -20)
    }
}
