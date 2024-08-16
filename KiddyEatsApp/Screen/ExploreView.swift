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
    
    @State private var currentTask: Task<Void, Never>?
    @State private var searchCancellable: AnyCancellable?
    @State private var hasLoadedInitialRecommendations: Bool = false
    
    private var displayedMeals: [BabyMeal] {
        if isLoading {
            return Array(repeating: BabyMeal(name: "", emoji: "", ingredients: [], allergens: [], cookingSteps: "", servingSize: 0, estimatedCookingTimeMinutes: 0), count: 6)
        } else {
            return babyMeals
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Try our recommendations for your 6 months old!")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(displayedMeals) { meal in
                            if isLoading {
                                ShimmeringRecipeCard()
                            } else {
                                NavigationLink(destination: MealDetailViewControllerRepresentable(babyMeal: meal)) {
                                    RecipeCard(babyMeal: meal)
                                }
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        if isLoading {
                            Button(action: cancelRecommendations) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Cancel")
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
                        Spacer()
                    }
                    .padding(.vertical)
                }
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
        await MainActor.run { isLoading = true }
        currentTask?.cancel()
        currentTask = Task {
            do {
                var jsonResponse = ""
                try await recommender.recommendMealsStreaming(profile: recommender.fakeBaby, searchQuery: searchText.isEmpty ? nil : searchText) { token in
                    jsonResponse += token
                    if let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonResponse) {
                        Task { @MainActor in
                            self.babyMeals = meals
                        }
                    }
                }
            } catch {
                print("Error refreshing recommendations: \(error)")
            }
            await MainActor.run {
                self.isLoading = false
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

struct RecipeCard: View {
    let babyMeal: BabyMeal
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text(babyMeal.emoji)
                    .font(.system(size: 60))
                    .frame(height: 100)
                
                Text(babyMeal.name)
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.accent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .top))
            .padding()
            .background(.exploreCardBackground)
            .cornerRadius(10)
            
            Button(action: {
                // Add heart action here
            }) {
                Image(systemName: "heart")
                    .foregroundColor(.accent)
            }
            .scaleEffect(1.5)
            .padding(.top, 15)
            .padding(.trailing, 15)
        }
    }
}

struct ShimmeringRecipeCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Color.white.opacity(0.2)
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.98), .clear]), startPoint: .leading, endPoint: .trailing)
                        )
                        .rotationEffect(.degrees(70))
                        .offset(x: isAnimating ? 400 : -400)
                )
        }
        .frame(height: 180)
        .cornerRadius(10)
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
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
