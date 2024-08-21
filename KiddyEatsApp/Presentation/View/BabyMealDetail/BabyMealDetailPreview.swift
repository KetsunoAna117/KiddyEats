//
//  BabyMealDetailPreview.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//
//  NOTE: Ini buat Live Preview UIKit

import SwiftUI

struct BabyMealDetailVCRepresentable: UIViewControllerRepresentable {
    @Environment(\.modelContext) var modelContext
    func makeUIViewController(context: Context) -> BabyMealDetailViewController {
        let sampleMeal = BabyMeal(
            name: "Sweet Potato Puree",
            emoji: "🍠",
            ingredients: ["1 medium sweet potato", "2 tablespoons breast milk or formula"],
            allergens: ["Milk"],
            cookingSteps: "1. Wash and peel the sweet potato.\n2. Cut into small cubes.\n3. Steam until soft, about 15 minutes.\n4. Mash or puree the sweet potato.\n5. Add breast milk or formula to achieve desired consistency.",
            servingSize: 2,
            estimatedCookingTimeMinutes: 20,
			isAllergic: false
        )
        return BabyMealDetailViewController(babyMeal: sampleMeal, modelContext: modelContext)
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}


struct BabyMealDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        BabyMealDetailVCRepresentable()
    }
}
