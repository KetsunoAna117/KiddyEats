//
//  ExploreView.swift
//  WeaningFoodAppSwiftUI
//
//  Created by Arya Adyatma on 15/08/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
//                Text("Welcome!")
//                
//                Text("Let's cook something 🍅")
//                    .font(.system(size: 20))
//                    .fontWeight(.semibold)
//                
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(Color(.tertiaryLabel))
//                    TextField("Search from ingredients", text: $searchText)
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(Color(.tertiarySystemFill))
//                .cornerRadius(10)
                
                Text("Try our recommendations for your 6 months old!")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(0..<6) { _ in
                            RecipeCard(emoji: "🍠", name: "Sweet Potato Noodles")
                        }
                    }
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.accentColor)
                        .padding(.top)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .background(.appBackground)
            .navigationTitle("Explore Recipes")

        }
        .searchable(text: $searchText, prompt: "Search new recipe by ingredients")

    }
}

struct RecipeCard: View {
    let emoji: String
    let name: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text(emoji)
                    .font(.system(size: 60))
                    .frame(height: 100)
                
                Text(name)
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.accent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .top))
            .padding()
            .background(.exploreCardBackground)
            .cornerRadius(10)
            
            Button(action: {
                // Add heart action here
            }) {
                Image(systemName: "heart")
                    .foregroundColor(.accent)
                    .padding(20)
            }
            .scaleEffect(1.5)
        }
    }
}

#Preview {
    ExploreView()
}
