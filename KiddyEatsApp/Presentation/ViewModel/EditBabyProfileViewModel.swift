//
//  EditBabyProfileViewModel.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 20/08/24.
//

import Foundation
import SwiftData

@Observable
class EditBabyProfileViewModel {
	
	var babyProfile: BabyProfile?
		
	// Use Case
	var getBabyProfileUseCase: GetBabyProfileDataProtocol
	// TODO: add variable to update baby profile
	var updateBabyProfileUseCase: UpdateBabyProfileDataProtocol
	
	init(
		getBabyProfileUseCase: GetBabyProfileDataProtocol,
		updateBabyProfileUseCase: UpdateBabyProfileDataProtocol
	) {
		self.getBabyProfileUseCase = getBabyProfileUseCase
		self.updateBabyProfileUseCase = updateBabyProfileUseCase
	}
	
	func initBabyProfile(modelContext: ModelContext) {
		self.babyProfile = getBabyProfileUseCase.execute(modelContext: modelContext)
		print(babyProfile)
	}
	
	func updateBabyProfile(modelContext: ModelContext) {
		//TODO: add function to update baby profile
		guard let existingBabyProfile = babyProfile else {
			print("No baby profile to update")
			return
		}
		
		updateBabyProfileUseCase.execute(modelContext: modelContext, toUpdateBabyProfile: existingBabyProfile)
	}
	
	func getAllergies() -> String {
		if let babyProfile = babyProfile {
			var allergyText = babyProfile.allergies.isEmpty ? "No allergies have been recorded." : "\(babyProfile.name) may be allergic to:\n"
			for allergy in babyProfile.allergies {
				allergyText += "- \(allergy)\n"
			}
			allergyText += "\nPlease consult your doctor for further information and assistance."
			return allergyText
		}
		return ""
	}
}
