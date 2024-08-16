//
//  User.swift
//  WeaningFoodAppSwiftUI
//
//  Created by Arya Adyatma on 15/08/24.
//

import Foundation

import Foundation

struct User {
    var babyProfile: BabyProfile
    
    var lastRecommendationDate: Date
    var todayRecommendations: [BabyMeal]
    
    // Meals favorited by the user
    var savedBabyMeals: [BabyMeal]
    
    // Meals logged as allergic
    var allergicBabyMeals: [BabyMeal]
    
    // Fungsi2 di bawah mungkin jatuhnya jadi use case
    func isAllergic(_ babyMeal: BabyMeal) -> Bool {
        // Berguna untuk bedain alergi di UI.
        return allergicBabyMeals.contains { allergicMeal in
            allergicMeal.id == babyMeal.id
        }
    }
    
    func shouldRefreshRecommendations() -> Bool {
        // Kalo udah ganti hari, ganti rekomendasi
        let calendar = Calendar.current
        return !calendar.isDate(lastRecommendationDate, inSameDayAs: Date())
    }
}
