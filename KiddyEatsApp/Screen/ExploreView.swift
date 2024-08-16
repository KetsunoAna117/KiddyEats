//
//  ExploreView.swift
//  WeaningFoodAppSwiftUI
//
//  Created by Arya Adyatma on 15/08/24.
//

import SwiftUI
import Combine
import UIKit


class BabyMealRecommenderUseCase {
    let aiService: AIService = AIService(identifier: FakeAPIKey.GPT4o.rawValue, isConversation: false)
    
    let fakeBaby = BabyProfile(
        name: "Nathan",
        gender: "Male",
        allergies: ["Eggs", "Peanuts"],
        dateOfBirth: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
        location: "Indonesia"
    )

    let fakeMeals = [
        BabyMeal(name: "Mashed Banana", emoji: "🍌", ingredients: ["banana"], allergens: [], cookingSteps: "Mash the banana until smooth.", servingSize: 1, estimatedCookingTimeMinutes: 5),
        BabyMeal(name: "Pureed Carrots", emoji: "🥕", ingredients: ["carrot"], allergens: [], cookingSteps: "Steam the carrots and puree until smooth.", servingSize: 1, estimatedCookingTimeMinutes: 15),
        BabyMeal(name: "Apple Sauce", emoji: "🍏", ingredients: ["apple"], allergens: [], cookingSteps: "Peel, core, and cook the apples until soft, then puree until smooth.", servingSize: 2, estimatedCookingTimeMinutes: 20)
    ]
    
    func recommendMeals(profile: BabyProfile, searchQuery: String? = nil) async -> [BabyMeal] {
        let babyProfileString = """
        Name: \(profile.name)
        Gender: \(profile.gender)
        Age: \(profile.ageMonths) months
        Location: \(profile.location)
        Allergies: [\(profile.allergies.joined(separator: ", "))]
        """
        
//        let commonFoodAllergies = "Peanuts, Tree nuts, Milk, Eggs, Soy, Wheat, Fish, Shellfish, Sesame, Corn, Celery, Mustard, Lupin, Sulfites, Gluten, Kiwi, Strawberries, Peaches, Avocado, Banana"
        let commonFoodAllergies = "Milk, Egg, Fish, Crustacean shellfish, Tree nuts, Peanuts, Wheat, Soybeans, Sesame"
        
        var llmPrompt = """
        You are an expert in child healthcare.
        
        Your job is to recommend baby meals based on baby profile.
        
        External Info - Common Food Allergies based on FDA:
        \(commonFoodAllergies)
        
        Use this JSON schema on your response:
        ```
        {
        "$schema": "http://json-schema.org/draft-07/schema#",
        "title": "BabyMeal",
        "type": "object",
        "properties": {
        "id": {
        "type": "string",
        "format": "uuid",
        "description": "Unique identifier for the meal"
        },
        "name": {
        "type": "string",
        "description": "Name of the meal"
        },
        "emoji": {
        "type": "string",
        "description": "Emoji representing the meal, one character. You can't use same emoji in same generation batch."
        },
        "ingredients": {
        "type": "array",
        "items": {
        "type": "string"
        },
        "description": "List of ingredients for the meal, include units separated by comma"
        },
        "allergens": {
        "type": "array",
        "items": {
        "type": "string"
        },
        "description": "List of potential allergies, each allergy must 1-2 words in title case."
        },
        "cookingSteps": {
        "type": "string",
        "description": "Steps to cook the meal in numbered list and newline."
        },
        "servingSize": {
        "type": "integer",
        "description": "Number of servings the meal provides"
        },
        "estimatedCookingTimeMinutes": {
        "type": "integer",
        "description": "Estimated cooking time in minutes"
        }
        },
        "required": ["id", "name", "emoji", "ingredients", "allergens", "cookingSteps", "servingSize", "estimatedCookingTimeMinutes"]
        }
        ```
        
        Rules:
        - Your returned ingredients must include units such as grams, tablespoons, teaspoon,
        - Don't forget to include potentialAllergies in your recommended foods if exists based on common food allergies or any other allergies.
        - Before the cooking guidelines, include "Serving Size: X" the number of serving size.
        - The cooking guidelines must step by step in numbered list using newline.
        - The emoji is only one character.
        - Wrap your response with JSON array.
        
        NEVER wrap your response data with triple backticks, just answer straight to the plain text json!
        
        TESTING = TRUE
        - For this time, you need to generate foods that have allergens. Include minimum 1 allergens.
        
        ---
        
        Please recommend 6 baby meals based on this baby profile:
        \(babyProfileString)
        """
        
        if searchQuery != nil {
            llmPrompt += "\n\nAlso use this search query: \(searchQuery!)"
        }
        
        print(llmPrompt)
        // Implement LLM API call and parse response
        let response = aiService.sendMessage(query: llmPrompt, uiImage: nil)
        
        // Convert response to list of meals
        let jsonData = Data(response.utf8)
        let decoder = JSONDecoder()
        
        do {
            let meals = try decoder.decode([BabyMeal].self, from: jsonData)
            return meals
        } catch DecodingError.dataCorrupted(let context) {
            print("Data corrupted: \(context.debugDescription)")
            return fakeMeals
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
            return fakeMeals
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch: \(context.debugDescription)")
            return fakeMeals
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Value of type '\(type)' not found: \(context.debugDescription)")
            return fakeMeals
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            return fakeMeals
        }
    }
}

struct ExploreView: View {
    @State private var searchText: String = ""
    @State private var babyMeals: [BabyMeal] = [
        BabyMeal(name: "Sweet Potato Noodles", emoji: "🍠", ingredients: ["Sweet Potato", "Olive Oil"], allergens: [], cookingSteps: "1. Peel and spiralize sweet potato\n2. Sauté in olive oil", servingSize: 1, estimatedCookingTimeMinutes: 15),
        BabyMeal(name: "Banana Puree", emoji: "🍌", ingredients: ["Banana"], allergens: [], cookingSteps: "1. Peel and mash banana", servingSize: 1, estimatedCookingTimeMinutes: 5),
    ]
    @State private var isLoading: Bool = false
    @State private var selectedMeal: BabyMeal?
    @State private var isShowingRecipeDetail: Bool = false
    
    private let recommender = BabyMealRecommenderUseCase()
    @State private var currentTask: Task<Void, Never>?
    @State private var searchCancellable: AnyCancellable?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Try our recommendations for your 6 months old!")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(isLoading ? Array(repeating: BabyMeal(name: "", emoji: "", ingredients: [], allergens: [], cookingSteps: "", servingSize: 0, estimatedCookingTimeMinutes: 0), count: 6) : babyMeals) { meal in
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
                            Button(action: refreshRecommendations) {
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
            .background(.appBackground)
            .navigationTitle("Explore Recipes")
        }
        .searchable(text: $searchText, prompt: "Search new recipe by ingredients")
        .onChange(of: searchText) { _ in
            if !searchText.isEmpty {
                debouncedSearch()
            }
        }
    }
    
    private func debouncedSearch() {
        searchCancellable?.cancel()
        searchCancellable = Just(searchText)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { _ in
                refreshRecommendations()
            }
    }
    
    private func refreshRecommendations() {
        isLoading = true
        currentTask?.cancel()
        currentTask = Task {
            let newMeals = await recommender.recommendMeals(profile: recommender.fakeBaby, searchQuery: searchText.isEmpty ? nil : searchText)
            if !Task.isCancelled {
                DispatchQueue.main.async {
                    babyMeals = newMeals
                    isLoading = false
                }
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
    
    func makeUIViewController(context: Context) -> MealDetailViewController {
        return MealDetailViewController(babyMeal: babyMeal)
    }
    
    func updateUIViewController(_ uiViewController: MealDetailViewController, context: Context) {}
}
