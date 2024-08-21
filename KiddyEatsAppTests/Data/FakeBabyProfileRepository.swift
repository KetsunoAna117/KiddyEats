//
//  FakeBabyProfileRepository.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 20/08/24.
//

import Foundation
import SwiftData
@testable import KiddyEatsApp

class FakeBabyProfileRepository: BabyProfileRepositoryProtocol {
    func getBabyProfile(modelContext: ModelContext) -> BabyProfileSchema? {
        return profiles.first
    }
    
    func createBabyProfile(modelContext: ModelContext, babyProfile: BabyProfileSchema) {
        let schema = babyProfile
        profiles.append(schema)
    }
    
    func updateBabyProfile(modelContext: ModelContext, toUpdateBabyProfile: BabyProfileSchema) {
        
    }
    
    var profiles: [BabyProfileSchema] = []
}
