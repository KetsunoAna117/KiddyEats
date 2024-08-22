//
//  UpdateBabyAllergenData.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 22/08/24.
//

import Foundation
import SwiftData

protocol UpdateBabyAllergenDataProtocol {
    func execute(modelContext: ModelContext, allergyList: [String])
}

struct UpdateBabyAllergenData: UpdateBabyAllergenDataProtocol {
    let repo: BabyProfileRepositoryProtocol
    
    func execute(modelContext: ModelContext, allergyList: [String]) {
        repo.updateBabyAllergies(modelContext: modelContext, toUpdateAllergies: allergyList)
    }
}
