//
//  BabyInformationViewModel.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import Foundation
import SwiftData

@Observable
class BabyOnboardingInformationViewModel {
    var savedbabyName: String = ""
    var savedbabyDOB: Date =  Date.now
    var savedbabyGender: Gender = .male
    var savedallergiesList: [String] = []
    
    // MARK: UseCase
    var useCase: CreateBabyProfileDataProtocol
    
    init(useCase: CreateBabyProfileDataProtocol) {
        self.useCase = useCase
    }
    
    func saveBabyProfileToSwiftData(modelContext: ModelContext){
        let babyProfile = BabyProfile(
            id: UUID(),
            name: savedbabyName,
            gender: savedbabyGender.rawValue,
            allergies: savedallergiesList,
            dateOfBirth: savedbabyDOB,
            location: "Indonesia"
        )
        
        useCase.execute(modelContext: modelContext, babyProfileData: babyProfile)
    }
}
