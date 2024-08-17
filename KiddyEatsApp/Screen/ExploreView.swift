import SwiftUI
import Combine

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Try our recommendations for your 6 months old!")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(viewModel.displayedMeals) { meal in
                                if meal.name.isEmpty {
                                    if viewModel.isLoading {
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
                        } else {
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
            .navigationTitle("Explore Recipes")
            .background(.appBackground)
        }
        .searchable(text: $viewModel.searchText, prompt: "AI recipe recommender by ingredients")
        .onChange(of: viewModel.searchText) {
            if !viewModel.searchText.isEmpty {
                viewModel.debouncedSearch()
            }
        }
        .onAppear {
            viewModel.loadInitialRecommendations()
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
