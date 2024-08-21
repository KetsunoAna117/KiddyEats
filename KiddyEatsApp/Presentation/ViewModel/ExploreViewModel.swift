//
//  ExploreViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import SwiftUI
import SwiftData
import Combine

@Observable
class ExploreViewModel {
    private var recommender: BabyMealRecommenderUseCase
    private var getBabyProfileUseCase: GetBabyProfileData
    
    private var modelContext: ModelContext?
    
    var searchText: String = ""
    var babyMeals: [BabyMeal] = []
    var previousRecommendedMeals: [BabyMeal] = [] // TODO: This list must max 12 items.
    var isLoading: Bool = false
    var errorMessage: String?
    var retryCount: Int = 0
    
    private var currentTask: Task<Void, Never>?
    private var searchCancellable: AnyCancellable?
    
    private var lastProcessingTime: Date = .distantPast
    private let processingInterval: TimeInterval = 0.2 // 200 milliseconds
    
    init(
        recommender: BabyMealRecommenderUseCase,
        getBabyProfileUseCase: GetBabyProfileData
    ) {
        self.recommender = recommender
        self.getBabyProfileUseCase = getBabyProfileUseCase
    }
    
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    func refreshRecommendations() async throws {
        isLoading = true
        babyMeals = []
        errorMessage = nil
        
        guard let modelContext = modelContext else {
            throw ResponseError.notFound(message: "Model Context is not initialized in refresh recommendation explore view model")
        }
        guard let babyProfile = getBabyProfileUseCase.execute(modelContext: modelContext) else {
            throw ResponseError.notFound(message: "Baby Profile is not detected")
        }
        currentTask?.cancel()
        currentTask = Task {
            do {
                var jsonResponse = ""
                try await recommender.recommendMealsStreaming(profile: babyProfile, searchQuery: searchText.isEmpty ? nil : searchText) { token in
                    
                    jsonResponse += token
                    jsonResponse = jsonResponse.replacing("```json", with: "")
                    
                    let currentTime = Date()
                    
                    if currentTime.timeIntervalSince(self.lastProcessingTime) >= self.processingInterval {
                        let newMeals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonResponse)
                        Task { @MainActor in
                            self.updateBabyMeals(with: newMeals)
                        }
                        self.lastProcessingTime = currentTime
                    }
                }
                
                try await Task.sleep(for: .seconds(0.2))
                
                jsonResponse = jsonResponse.replacing("```", with: "")
                
                // Parse the complete JSON after streaming ends
                if let data = jsonResponse.data(using: .utf8) {
                    do {
                        let meals = try JSONDecoder().decode([BabyMeal].self, from: data)
                        Task { @MainActor in
                            self.updateBabyMeals(with: meals)
                        }
                    } catch {
                        print("Error decoding complete JSON: \(error)")
                        // Fallback to incomplete JSON parsing if complete parsing fails
                        let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonResponse)
                        Task { @MainActor in
                            self.updateBabyMeals(with: meals)
                        }
                    }
                }
                retryCount = 0
            } catch {
                if !error.localizedDescription.contains("cancel") {
                    await MainActor.run {
                        print("Error refreshing recommendations: \(error)")
                        self.errorMessage = "Oops! We failed to communicate with AI system. No worries, you can try again later."
                    }
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func updateBabyMeals(with newMeals: [BabyMeal]) {
        for newMeal in newMeals {
            if !self.babyMeals.contains(where: { $0.name == newMeal.name }) {
                self.babyMeals.append(newMeal)
            }
        }
    }
    
    func cancelRecommendations() {
        currentTask?.cancel()
        isLoading = false
    }
    
    func debouncedSearch() {
        cancelRecommendations()
        searchCancellable?.cancel()
        searchCancellable = Just(searchText)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { [weak self] in
                    try await self?.refreshRecommendations()
                }
            }
    }
}
