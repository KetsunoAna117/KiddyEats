//
//  BabyProfileRepositoryTests.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 20/08/24.
//
import XCTest
@testable import KiddyEatsApp

class ExploreViewModelTests: XCTestCase {
    var viewModel: ExploreViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ExploreViewModel(
            recommender: BabyMealRecommenderUseCase(),
            getBabyProfileUseCase: GetBabyProfileData(repo: BabyProfileRepositoryImpl.shared)
        )
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.babyMeals.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearchTextUpdate() {
        viewModel.searchText = "apple"
        XCTAssertEqual(viewModel.searchText, "apple")
    }
    
    func testCancelRecommendations() {
        viewModel.isLoading = true
        
        viewModel.cancelRecommendations()
        
        XCTAssertFalse(viewModel.isLoading)
    }
}
