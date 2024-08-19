//
//  BabyInformationViewModel.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import Foundation

@Observable
class BabyInformationViewModel {
    var babyName: String
    var babyDOB: Date
    var babyGender: Gender
    var allergiesList: [String]
    
    init() {
        self.babyName = ""
        self.babyDOB = Date.now
        self.babyGender = .male
        self.allergiesList = []
    }
    
}
