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
    func createBabyProfile(modelContext: ModelContext, babyProfile: BabyProfileSchema) {
        modelContext.insert(babyProfile)
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
	
	//TODO: Add function to update baby profile swiftdata
	func updateBabyProfile(modelContext: ModelContext, toUpdateBabyProfile: BabyProfileSchema) {
		if let existingBabyProfile = getBabyProfile(modelContext: modelContext) {
			existingBabyProfile.name = toUpdateBabyProfile.name
			existingBabyProfile.allergies = toUpdateBabyProfile.allergies
			existingBabyProfile.dateOfBirth = toUpdateBabyProfile.dateOfBirth
			try? modelContext.save()
		}
	}
    
    func updateBabyAllergies(modelContext: ModelContext, toUpdateAllergies: [String]) {
        if let existingBabyProfile = getBabyProfile(modelContext: modelContext) {
            
            for allergy in toUpdateAllergies {
                // if already has allergies, don't append
                if existingBabyProfile.allergies?.contains(allergy) == false {
                    existingBabyProfile.allergies?.append(allergy)
                }
            }
            
            try? modelContext.save()
        }
    }

}
