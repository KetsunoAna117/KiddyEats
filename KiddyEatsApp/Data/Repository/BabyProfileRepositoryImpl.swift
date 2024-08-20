//
//  BabyProfileRepository.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

struct BabyProfileRepositoryImpl {
    private init(){}
    
    static let shared = BabyProfileRepositoryImpl()
}

extension BabyProfileRepositoryImpl: BabyProfileRepositoryProtocol {
    func createBabyProfile(modelContext: ModelContext, babyProfile: BabyProfile) {
        modelContext.insert(babyProfile.mapToBabyProfileSchema())
        try? modelContext.save()
    }
    
    
    func getBabyProfile(modelContext: ModelContext) -> BabyProfileSchema? {
        let descriptor = FetchDescriptor<BabyProfileSchema>()
        
        guard let fetchedBabyProfile = try? modelContext.fetch(descriptor) else {
            print("There's no baby profile schema in db")
            return nil
        }
        
        return fetchedBabyProfile.first
    }
}
