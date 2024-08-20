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
    var profiles: [BabyProfileSchema] = []
    
    func createBabyProfile(modelContext: ModelContext, babyProfile: BabyProfile) {
        let schema = babyProfile.mapToBabyProfileSchema()
        profiles.append(schema)
    }
    
    func getBabyProfile(modelContext: ModelContext) -> BabyProfileSchema? {
        return profiles.first
    }
}
