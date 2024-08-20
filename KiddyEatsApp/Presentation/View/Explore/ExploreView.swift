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
                        if let errorMessage = viewModel.errorMessage {
                            ErrorView(message: errorMessage) {
                                Task {
                                    await viewModel.refreshRecommendations()
                                }
                            }
                        } else {
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

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}


#Preview {
    ExploreView()
        .environment(ExploreViewModel())
}
