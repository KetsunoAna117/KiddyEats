//
//  UpdateBabyProfileData.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

protocol UpdateBabyProfileDataProtocol {
	func execute(modelContext: ModelContext, toUpdateBabyProfile: BabyProfile)
}

struct UpdateBabyProfileData: UpdateBabyProfileDataProtocol {
	let repo: BabyProfileRepositoryProtocol
	
	func execute(modelContext: ModelContext, toUpdateBabyProfile: BabyProfile) {
		repo.updateBabyProfile(modelContext: modelContext, toUpdateBabyProfile: toUpdateBabyProfile)
	}
}
