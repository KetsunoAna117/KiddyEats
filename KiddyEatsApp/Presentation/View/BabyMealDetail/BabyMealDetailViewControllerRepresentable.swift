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
        let viewController = BabyMealDetailViewController(babyMeal: babyMeal)
        viewController.title = babyMeal.name
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}
