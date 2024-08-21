//
//  RecipeCardPlaceholder.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//
import SwiftUI

struct RecipeCardPlaceholder: View {
    var body: some View {
        ZStack {
            Color.exploreCardBackground
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                .scaleEffect(1.5)
        }
        .frame(height: 220)
        .cornerRadius(10)
    }
}
