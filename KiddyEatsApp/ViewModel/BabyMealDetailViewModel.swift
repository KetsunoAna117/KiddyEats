//
//  BabyMealDetailViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//


class BabyMealDetailViewModel {
    let babyMeal: BabyMeal
    var isFavorite: Bool = false
    
    init(babyMeal: BabyMeal) {
        self.babyMeal = babyMeal
    }
    
    func addToLog() {
        // Implement add to log functionality
        print("Add to log tapped")
    }
}
