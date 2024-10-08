//
//  BabyMealDetailPreview.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//
//  NOTE: Ini buat Live Preview UIKit

import SwiftUI

struct BabyMealDetailVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BabyMealDetailViewController {
        let sampleMeal = BabyMeal(
            name: "Sweet Potato Puree",
            emoji: "🍠",
            ingredients: [
                "Sweet potato, 3 pcs, very high quality and allergen free",
                "Breast milk, 2 tbsp",
            ],
            allergens: ["Milk"],
            cookingSteps: "1. Wash and peel the sweet potato.\n2. Cut into small cubes.\n3. Steam until soft, about 15 minutes.\n4. Mash or puree the sweet potato.\n5. Add breast milk or formula to achieve desired consistency.",
            servingSize: 2,
            estimatedCookingTimeMinutes: 20,
			isAllergic: false,
            hasFilledReaction: false,
            reactionList: [
                "Sneezing"
            ]
        )
        return BabyMealDetailViewController(babyMeal: sampleMeal)
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}


#Preview {        
    BabyMealDetailVCRepresentable()
        .modelContainer(ModelContextManager.createModelContainer())
}

