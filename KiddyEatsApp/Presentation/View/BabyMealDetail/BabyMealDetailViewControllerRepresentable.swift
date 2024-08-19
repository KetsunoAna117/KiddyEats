//
//  BabyMealDetailViewControllerRepresentable.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import SwiftUI

struct MealDetailViewControllerRepresentable: UIViewControllerRepresentable {
    let babyMeal: BabyMeal
    
    func makeUIViewController(context: Context) -> BabyMealDetailViewController {
        return BabyMealDetailViewController(babyMeal: babyMeal)
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}
