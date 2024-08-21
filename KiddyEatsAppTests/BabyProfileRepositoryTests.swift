//
//  BabyProfileRepositoryTests.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 20/08/24.
//

import XCTest
import SwiftData
@testable import KiddyEatsApp

class BabyProfileRepositoryTests: XCTestCase {
    var repository: FakeBabyProfileRepository!
    var modelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        repository = FakeBabyProfileRepository()
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: BabyProfileSchema.self, configurations: config)
        modelContext = ModelContext(container)
    }
    
    override func tearDown() {
        repository = nil
        modelContext = nil
        super.tearDown()
    }
    
    func testCreateBabyProfile() {
        let babyProfile = BabyProfile(id: UUID(), name: "Test Baby", gender: "Male", allergies: ["Peanuts"], dateOfBirth: Date(), location: "Test Location")
        
        repository.createBabyProfile(modelContext: modelContext, babyProfile: babyProfile)
        
        XCTAssertEqual(repository.profiles.count, 1)
        XCTAssertEqual(repository.profiles.first?.name, "Test Baby")
    }
    
    func testGetBabyProfile() {
        let babyProfile = BabyProfile(id: UUID(), name: "Test Baby", gender: "Female", allergies: ["Milk"], dateOfBirth: Date(), location: "Test Location")
        repository.createBabyProfile(modelContext: modelContext, babyProfile: babyProfile)
        
        let retrievedProfile = repository.getBabyProfile(modelContext: modelContext)
        
        XCTAssertNotNil(retrievedProfile)
        XCTAssertEqual(retrievedProfile?.name, "Test Baby")
        XCTAssertEqual(retrievedProfile?.gender, "Female")
    }
    
    func testGetBabyProfileWhenEmpty() {
        let retrievedProfile = repository.getBabyProfile(modelContext: modelContext)
        
        XCTAssertNil(retrievedProfile)
    }
    
    func testCreateMultipleBabyProfiles() {
        let babyProfile1 = BabyProfile(id: UUID(), name: "Baby 1", gender: "Male", allergies: [], dateOfBirth: Date(), location: "Location 1")
        let babyProfile2 = BabyProfile(id: UUID(), name: "Baby 2", gender: "Female", allergies: ["Eggs"], dateOfBirth: Date(), location: "Location 2")
        
        repository.createBabyProfile(modelContext: modelContext, babyProfile: babyProfile1)
        repository.createBabyProfile(modelContext: modelContext, babyProfile: babyProfile2)
        
        XCTAssertEqual(repository.profiles.count, 2)
        XCTAssertEqual(repository.getBabyProfile(modelContext: modelContext)?.name, "Baby 1") // Should return the first profile
    }
}
