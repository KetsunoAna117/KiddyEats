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
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Try our recommendations for your 6 months old!")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                ScrollView {
                    VStack(spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(exploreVM.babyMeals) { meal in
                                NavigationLink(destination: MealDetailViewControllerRepresentable(babyMeal: meal)) {
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
                        
                        if exploreVM.isLoading {
                            Button(action: exploreVM.cancelRecommendations) {
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
                        } else if exploreVM.errorMessage == nil {
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
                    try? await exploreVM.refreshRecommendations()
                }
            }
        }
        .onAppear {
            self.exploreVM.setModelContext(modelContext: modelContext)
            
        }
    }
}


#Preview {
    ExploreView()
        .modelContainer(for: [BabyMealSchema.self, BabyProfileSchema.self], inMemory: true) { container in
            createAndInsertFakeBabyProfile(in: container)
        }
}

func createAndInsertFakeBabyProfile(in container: ModelContainer) {
    let context = ModelContext(container)
    let fakeBabyProfile = BabyProfileSchema(
        id: UUID(),
        name: "Baby Doe",
        gender: "Female",
        allergies: ["Peanuts", "Eggs"],
        dateOfBirth: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
        location: "New York"
    )
    context.insert(fakeBabyProfile)
}
