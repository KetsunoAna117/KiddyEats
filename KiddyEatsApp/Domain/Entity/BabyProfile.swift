//
//  BabyMeal.swift
//  WeaningFoodApp
//
//  Created by Arya Adyatma on 15/08/24.
//

import Foundation

struct BabyProfile: Identifiable {
    var id: UUID
    var name: String
    var gender: String
    var allergies: [String]
    var dateOfBirth: Date
    var location: String
    
    var ageMonths: Int  {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: dateOfBirth, to: Date())
        let month = components.month ?? 0
        return max(month, 6)
    }
    
    func mapToBabyProfileSchema() -> BabyProfileSchema {
        return BabyProfileSchema(
            id: self.id,
            name: self.name,
            gender: self.gender,
            allergies: self.allergies,
            dateOfBirth: self.dateOfBirth,
            location: self.location
        )
    }
}
