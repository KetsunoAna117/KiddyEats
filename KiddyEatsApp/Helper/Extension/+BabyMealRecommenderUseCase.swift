//
//  +BabyMealRecommenderUseCase.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import Foundation

extension BabyMealRecommenderUseCase {
    typealias MealRecommendationCallback = (String) -> Void
    
    // NOTE: Nanti ini bakal sesuai profile bayi
    var fakeBaby: BabyProfile {
        BabyProfile(
            name: "Nathan",
            gender: "Male",
            allergies: ["Eggs", "Peanuts"],
            dateOfBirth: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
            location: "Indonesia"
        )
    }
}
