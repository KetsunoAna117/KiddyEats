//
//  RecipeCard.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 16/08/24.
//

import SwiftUI

struct RecipeCard: View {
    let babyMeal: BabyMeal
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if babyMeal.name.isEmpty {
                LoadingCard()
            } else {
                VStack {
                    Text(babyMeal.emoji)
                        .font(.system(size: 60))
                        .frame(height: 100)
                    
                    Text(babyMeal.name)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .top))
                .padding()
                .background(Color.exploreCardBackground)
                .cornerRadius(10)
                
                Button(action: {
                    // Add heart action here
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.accent)
                }
                .scaleEffect(1.5)
                .padding(.top, 15)
                .padding(.trailing, 15)
            }
        }
    }
}
