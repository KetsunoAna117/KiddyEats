//
//  ExploreViewModel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import SwiftUI
import Combine

@Observable
class ExploreViewModel {
    private let recommender = BabyMealRecommenderUseCase()
    
    var searchText: String = ""
    var babyMeals: [BabyMeal] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var hasLoadedInitialRecommendations: Bool = false
    var retryCount: Int = 0
    
    private var currentTask: Task<Void, Never>?
    private var searchCancellable: AnyCancellable?
    
    var displayedMeals: [BabyMeal] {
        let meals = babyMeals + Array(repeating: BabyMeal(name: "", emoji: "", ingredients: [], allergens: [], cookingSteps: "", servingSize: 0, estimatedCookingTimeMinutes: 0), count: max(0, 6 - babyMeals.count))
        return Array(meals.prefix(6))
    }
    
    func loadInitialRecommendations() {
        guard !hasLoadedInitialRecommendations else { return }
        Task {
            await refreshRecommendations()
            hasLoadedInitialRecommendations = true
        }
    }
    
    func refreshRecommendations() async {
        isLoading = true
        babyMeals = []
        errorMessage = nil
        
        currentTask?.cancel()
        currentTask = Task {
            do {
                var jsonResponse = ""
                try await recommender.recommendMealsStreaming(profile: recommender.fakeBaby, searchQuery: searchText.isEmpty ? nil : searchText) { token in
                    jsonResponse += token
                    let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonResponse)
                    Task { @MainActor in
                        self.babyMeals = meals
                    }
                }
                retryCount = 0
            } catch {
                print("Error refreshing recommendations: \(error)")
                await handleRecommendationError(error)
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func cancelRecommendations() {
        currentTask?.cancel()
        isLoading = false
    }
    
    func debouncedSearch() {
        searchCancellable?.cancel()
        searchCancellable = Just(searchText)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { [weak self] in
                    await self?.refreshRecommendations()
                }
            }
    }
    
    private func handleRecommendationError(_ error: Error) async {
        await MainActor.run {
            if retryCount < 3 {
                retryCount += 1
                errorMessage = "Failed to load recommendations. Retrying... (Attempt \(retryCount)/3)"
                Task {
                    try await Task.sleep(for: .seconds(2))
                    await refreshRecommendations()
                }
            } else {
                errorMessage = "Failed to load recommendations. Please try again later."
                retryCount = 0
            }
        }
    }
}
