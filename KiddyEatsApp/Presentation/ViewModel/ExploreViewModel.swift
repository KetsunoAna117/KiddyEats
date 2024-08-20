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
    var previousRecommendedMeals: [BabyMeal] = [] // TODO: This list must max 12 items.
    var isLoading: Bool = false
    var errorMessage: String?
    var retryCount: Int = 0
    
    private var currentTask: Task<Void, Never>?
    private var searchCancellable: AnyCancellable?
    
    private var lastProcessingTime: Date = .distantPast
    private let processingInterval: TimeInterval = 0.2 // 200 milliseconds
    
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
                    jsonResponse = jsonResponse.replacing("```json", with: "")
                    
                    let currentTime = Date()
                    
                    if currentTime.timeIntervalSince(self.lastProcessingTime) >= self.processingInterval {
                        let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonResponse)
                        Task { @MainActor in
                            self.babyMeals = meals
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
                            self.babyMeals = meals
                        }
                    } catch {
                        print("Error decoding complete JSON: \(error)")
                        // Fallback to incomplete JSON parsing if complete parsing fails
                        let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonResponse)
                        Task { @MainActor in
                            self.babyMeals = meals
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
}
