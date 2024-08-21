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
	func updateBabyProfile(modelContext: ModelContext, toUpdateBabyProfile: BabyProfile) {
		if let existingBabyProfile = getBabyProfile(modelContext: modelContext) {
			existingBabyProfile.name = toUpdateBabyProfile.name
			existingBabyProfile.gender = toUpdateBabyProfile.gender
			existingBabyProfile.allergies = toUpdateBabyProfile.allergies
			existingBabyProfile.dateOfBirth = toUpdateBabyProfile.dateOfBirth
			existingBabyProfile.location = toUpdateBabyProfile.location
			try? modelContext.save()
		}
	}

}
