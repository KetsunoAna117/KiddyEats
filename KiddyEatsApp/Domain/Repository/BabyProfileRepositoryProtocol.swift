//
//  BabyRepositoryProtocol.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

protocol BabyProfileRepositoryProtocol {
    func getBabyProfile(modelContext: ModelContext) -> BabyProfileSchema?
    func createBabyProfile(modelContext: ModelContext, babyProfile: BabyProfileSchema)
	// TODO: Add update baby profile method swiftdata
	func updateBabyProfile(modelContext: ModelContext, toUpdateBabyProfile: BabyProfileSchema)
    func updateBabyAllergies(modelContext: ModelContext, toUpdateAllergies: [String])
}
