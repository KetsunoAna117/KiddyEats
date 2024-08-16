//
//  ExploreView.swift
//  WeaningFoodAppSwiftUI
//
//  Created by Arya Adyatma on 15/08/24.
//

import SwiftUI
import Combine
import UIKit


struct ExploreView: View {
    private let recommender = BabyMealRecommenderUseCase()

    @State private var searchText: String = ""
    @State private var babyMeals: [BabyMeal] = []
    @State private var isLoading: Bool = false
    @State private var selectedMeal: BabyMeal?
    @State private var isShowingRecipeDetail: Bool = false
    @State private var errorMessage: String?
    
    @State private var currentTask: Task<Void, Never>?
    @State private var searchCancellable: AnyCancellable?
    @State private var hasLoadedInitialRecommendations: Bool = false
    @State private var retryCount: Int = 0
    
    private var displayedMeals: [BabyMeal] {
        let meals = babyMeals + Array(repeating: BabyMeal(name: "", emoji: "", ingredients: [], allergens: [], cookingSteps: "", servingSize: 0, estimatedCookingTimeMinutes: 0), count: max(0, 6 - babyMeals.count))
        return Array(meals.prefix(6))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Try our recommendations for your 6 months old!")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(displayedMeals) { meal in
                                if meal.name.isEmpty {
                                    if isLoading {
                                        RecipeCardPlaceholder()
                                    } else {
                                        RecipeCard(babyMeal: meal)
                                    }
                                } else {
                                    NavigationLink(destination: MealDetailViewControllerRepresentable(babyMeal: meal)) {
                                        RecipeCard(babyMeal: meal)
                                    }
                                }
                            }
                        }
                        
                        if isLoading {
                            Button(action: cancelRecommendations) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Stop")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.red)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(20)
                            }
                        } else {
                            Button(action: {
                                Task {
                                    await refreshRecommendations()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                    Text("Refresh")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.accentColor)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.accentColor.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top)
            .padding(.horizontal)
            .navigationTitle("Explore Recipes")
            .background(.appBackground)
        }
        .searchable(text: $searchText, prompt: "AI recipe recommender by ingredients")
        .onChange(of: searchText) { _ in
            if !searchText.isEmpty {
                debouncedSearch()
            }
        }
        .onAppear {
            loadInitialRecommendations()
        }
    }
    
    private func debouncedSearch() {
        searchCancellable?.cancel()
        searchCancellable = Just(searchText)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { _ in
                Task {
                    await refreshRecommendations()
                }
            }
    }
    
    private func loadInitialRecommendations() {
        guard !hasLoadedInitialRecommendations else { return }
        Task {
            await refreshRecommendations()
            hasLoadedInitialRecommendations = true
        }
    }

    private func refreshRecommendations() async {
        await MainActor.run { 
            isLoading = true
            babyMeals = []
            errorMessage = nil
        }
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
    
    private func handleRecommendationError(_ error: Error) async {
        await MainActor.run {
            if retryCount < 3 {
                retryCount += 1
                errorMessage = "Failed to load recommendations. Retrying... (Attempt \(retryCount)/3)"
                Task {
                    try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds delay
                    await refreshRecommendations()
                }
            } else {
                errorMessage = "Failed to load recommendations. Please try again later."
                retryCount = 0
            }
        }
    }
    
    private func cancelRecommendations() {
        currentTask?.cancel()
        DispatchQueue.main.async {
            isLoading = false
        }
    }
}


struct LoadingCard: View {
    var body: some View {
        ZStack {
            Color.exploreCardBackground
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                .scaleEffect(1.5)
        }
        .frame(height: 180)
        .cornerRadius(10)
    }
}

#Preview {
    ExploreView()
}

struct MealDetailViewControllerRepresentable: UIViewControllerRepresentable {
    let babyMeal: BabyMeal
    
    func makeUIViewController(context: Context) -> BabyMealDetailViewController {
        return BabyMealDetailViewController(babyMeal: babyMeal)
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}
struct RecipeCardPlaceholder: View {
    var body: some View {
        ZStack {
            Color.exploreCardBackground
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                .scaleEffect(1.5)
        }
        .frame(height: 180)
        .cornerRadius(10)
    }
}
