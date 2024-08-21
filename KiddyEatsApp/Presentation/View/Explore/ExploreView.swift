//
//  ExploreView.swift
//  WeaningFoodAppSwiftUI
//
//  Created by Arya Adyatma on 15/08/24.
//

import SwiftUI
import SwiftData
import Combine

struct ExploreView: View {
    @Environment(\.modelContext) var modelContext
    @State private var exploreVM = ExploreViewModel(
        recommender: BabyMealRecommenderUseCase(),
        getBabyProfileUseCase:
            GetBabyProfileData(repo: BabyProfileRepositoryImpl.shared)
    )
    
    var body: some View {
        let babyName = exploreVM.babyProfile?.name ?? "Baby"
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Text("Try our newest recommendations for\n\(babyName)!")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                    Spacer()
                    if exploreVM.isLoading {
                        Button(action: exploreVM.cancelRecommendations) {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                            }
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.accentColor)
                        }
                    } else {
                        Button(action: {
                            Task {
                                do {
                                    try await exploreVM.refreshRecommendations()
                                } catch {
                                    print(error)
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise.circle.fill")
                            }
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(exploreVM.babyMeals) { meal in
                                NavigationLink(destination: MealDetailViewControllerRepresentable(babyMeal: meal)
                                    .navigationTitle(meal.name)) {
                                    RecipeCard(babyMeal: meal)
                                }
                            }
                            if exploreVM.isLoading && exploreVM.babyMeals.count < 6 {
                                RecipeCardPlaceholder()
                            }
                        }
                        
                        if let errorMessage = exploreVM.errorMessage {
                            ErrorContainer(message: errorMessage) {
                                Task {
                                    do {
                                        try await exploreVM.refreshRecommendations()
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top)
            .padding(.horizontal)
            .searchable(text: $exploreVM.searchText, prompt: "AI recipe recommender by ingredients")
            .navigationTitle("Explore Recipes")
            .background(.appBackground)
        }
        .onChange(of: exploreVM.searchText) {
            if !exploreVM.searchText.isEmpty {
                exploreVM.debouncedSearch()
            }
        }
        .onAppear {
            if exploreVM.babyMeals.isEmpty && exploreVM.errorMessage == nil {
                Task {
                    // NOTE: Uncomment this to make it refresh on appear
//                    try? await exploreVM.refreshRecommendations()
                }
            }
        }
        .onAppear {
            self.exploreVM.initViewModel(modelContext: modelContext)
            
        }
    }
}

#Preview {
    let container: ModelContainer = {
        do {
            let container = ModelContextManager.createModelContainer()
            let context = container.mainContext
            
            // Create and insert fake baby profile
            let fakeBabyProfile = BabyProfileSchema(
                id: UUID(),
                name: "Baby Doe",
                gender: "Female",
                allergies: ["Peanuts", "Eggs"],
                dateOfBirth: Calendar.current.date(byAdding: .month, value: -7, to: Date())!,
                location: "New York"
            )
            context.insert(fakeBabyProfile)
            
            return container
        } catch {
            fatalError("Failed to create container: \(error.localizedDescription)")
        }
    }()

    return ExploreView()
        .modelContainer(container)
}
