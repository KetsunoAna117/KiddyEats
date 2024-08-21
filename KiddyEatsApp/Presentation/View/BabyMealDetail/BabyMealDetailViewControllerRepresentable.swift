//
//  BabyMealDetailViewControllerRepresentable.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import SwiftUI

struct MealDetailViewControllerRepresentable: UIViewControllerRepresentable {
    @Environment(\.modelContext) var modelContext
    let babyMeal: BabyMeal
    
    func makeUIViewController(context: Context) -> BabyMealDetailViewController {
        return BabyMealDetailViewController(babyMeal: babyMeal, modelContext: modelContext)
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}
