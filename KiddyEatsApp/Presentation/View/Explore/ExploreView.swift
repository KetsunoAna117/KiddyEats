//
//  ExploreView.swift
//  WeaningFoodAppSwiftUI
//
//  Created by Arya Adyatma on 15/08/24.
//

import SwiftUI
import Combine

struct ExploreView: View {
    @Environment(ExploreViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
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
                                    await viewModel.refreshRecommendations()
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
                                    await viewModel.refreshRecommendations()
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
                    await viewModel.refreshRecommendations()
                }
            }
        }
    }
}

struct ErrorContainer: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .cornerRadius(10)
    }
}


#Preview {
    ExploreView()
        .environment(ExploreViewModel())
}
