//
//  BabyGlobalConfigurationViewModel.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation
import SwiftData

@Observable class BabyGlobalConfigurationViewModel {
    // MARK: Variable
    var babyProfile: BabyProfile?
    
    // MARK: Use Case
    var babyDataFetcherUseCase: GetBabyProfileDataProtocol
    
    init(babyDataFetcherUseCase: GetBabyProfileDataProtocol) {
        self.babyDataFetcherUseCase = babyDataFetcherUseCase
    }
    
    // MARK: Functions
    func getBabyProfileData(modelContext: ModelContext){
        self.babyProfile = babyDataFetcherUseCase.execute(modelContext: modelContext)
    }
    
}
