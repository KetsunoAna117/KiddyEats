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
    @State private var viewModel = ExploreViewModel(
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
                            ForEach(viewModel.babyMeals) { meal in
                                NavigationLink(destination: MealDetailViewControllerRepresentable(babyMeal: meal)) {
                                    RecipeCard(babyMeal: meal)
                                }
                            }
                            if viewModel.isLoading && viewModel.babyMeals.count < 6 {
                                RecipeCardPlaceholder()
                            }
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            ErrorContainer(message: errorMessage) {
                                Task {
                                    do {
                                        try await viewModel.refreshRecommendations()
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                            }
                        }
                        
                        if viewModel.isLoading {
                            Button(action: viewModel.cancelRecommendations) {
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
                        } else if viewModel.errorMessage == nil {
                            Button(action: {
                                Task {
                                    do {
                                        try await viewModel.refreshRecommendations()
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
            .searchable(text: $viewModel.searchText, prompt: "AI recipe recommender by ingredients")
            .navigationTitle("Explore Recipes")
            .background(.appBackground)
        }
        .onChange(of: viewModel.searchText) {
            if !viewModel.searchText.isEmpty {
                viewModel.debouncedSearch()
            }
        }
        .onAppear {
            if viewModel.babyMeals.isEmpty && viewModel.errorMessage == nil {
                Task {
                    // NOTE: Uncomment this to make it refresh on appear
                    try? await viewModel.refreshRecommendations()
                }
            }
        }
        .onAppear {
            self.viewModel.setModelContext(modelContext: modelContext)
        }
    }
}


#Preview {
    ExploreView()
}
