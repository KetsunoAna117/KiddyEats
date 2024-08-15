//
//  BabyMeal.swift
//  WeaningFoodApp
//
//  Created by Arya Adyatma on 15/08/24.
//

import Foundation

struct BabyProfile: Identifiable {
    let id = UUID()
    let name: String
    let gender: String
    let allergies: [String]
    let dateOfBirth: Date
    let location: String
    
    var ageMonths: Int  {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: dateOfBirth, to: Date())
        return components.month ?? 0
    }
}
