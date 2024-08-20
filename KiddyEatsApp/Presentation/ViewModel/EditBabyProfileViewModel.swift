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
	
	//TODO: add function to update baby profile
	func updateBabyProfile(modelContext: ModelContext) {
		
	}
}
