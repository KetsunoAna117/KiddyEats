//
//  BabyMeal.swift
//  WeaningFoodApp
//
//  Created by Arya Adyatma on 15/08/24.
//

import Foundation

struct BabyProfile: Identifiable {
    var id = UUID()
    var name: String
    var gender: String
    var allergies: [String]
    var dateOfBirth: Date
    var location: String
    
    var ageMonths: Int  {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: dateOfBirth, to: Date())
        return components.month ?? 0
    }
}
