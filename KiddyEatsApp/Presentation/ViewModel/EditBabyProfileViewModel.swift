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
	
	var fetchedBabyProfile: BabyProfile?
    
    var toUpdateBabyName: String = ""
    var toUpdateBabyDate: Date = Date.now
    var toUpdateAllergenList: [String] = []
		
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
		self.fetchedBabyProfile = getBabyProfileUseCase.execute(modelContext: modelContext)
	}
	
	func updateBabyProfile(modelContext: ModelContext) {
		//TODO: add function to update baby profile
		guard let existingBabyProfile = fetchedBabyProfile else {
			print("No baby profile to update")
			return
		}
		
		updateBabyProfileUseCase.execute(modelContext: modelContext, toUpdateBabyProfile: existingBabyProfile)
	}
    
    func setupViewModel(){
        if let fetchedBabyProfile = fetchedBabyProfile {
            toUpdateBabyName = fetchedBabyProfile.name
            toUpdateBabyDate = fetchedBabyProfile.dateOfBirth
            toUpdateAllergenList = fetchedBabyProfile.allergies
        }
        
    }
}
