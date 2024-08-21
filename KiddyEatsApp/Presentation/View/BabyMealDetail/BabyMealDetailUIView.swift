//
//  BabyMealDetailView.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 17/08/24.
//

import SwiftUI
import UIKit

class BabyMealDetailUIView: UIView {
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var emojiLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var allergensView = UIView()
    private lazy var recipeInfoLabel = UILabel()
    private lazy var ingredientsLabel = UILabel()
    private lazy var cookingInstructionsLabel = UILabel()
    
    private lazy var addToLogButton = UIButton(type: .system) // NOTE: Nanti mungkin jadi SwiftUI
    private lazy var viewIfSavedToCollection = UIView()
    
    private var viewModel: BabyMealDetailViewModel
    private var babyMeal: BabyMeal
    private var isAlreadySaved: Bool
    
    init(viewModel: BabyMealDetailViewModel, babyMeal: BabyMeal, isAlreadySaved: Bool) {
        self.viewModel = viewModel
        self.babyMeal = babyMeal
        self.isAlreadySaved = isAlreadySaved
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        setupScrollView()
        setupEmojiLabel()
        setupTitle()
        setupAllergensView()
        setupRecipeInfo()
        setupIngredients()
        setupCookingInstructions()
        setupAddToCollectionButton()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupEmojiLabel() {
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = self.babyMeal.emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 80)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .systemGray6
        emojiLabel.layer.cornerRadius = 8
        emojiLabel.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 100),
            emojiLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = self.babyMeal.name
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAllergensView() {
        contentView.addSubview(allergensView)
        allergensView.translatesAutoresizingMaskIntoConstraints = false
        allergensView.backgroundColor = .possibleAllergen
        allergensView.layer.cornerRadius = 8
        
        let allergensTitleStack = UIStackView()
        allergensTitleStack.translatesAutoresizingMaskIntoConstraints = false
        allergensTitleStack.axis = .horizontal
        allergensTitleStack.spacing = 4
        
        let allergenTitleImage = UIImageView()
        allergenTitleImage.image = UIImage(systemName: "exclamationmark.triangle")
        
        let allergensTitle = UILabel()
        allergensTitle.translatesAutoresizingMaskIntoConstraints = false
        allergensTitle.text = "Possible Allergens"
        allergensTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        allergensTitle.textColor = .black
        
        allergensTitleStack.addArrangedSubview(allergenTitleImage)
        allergensTitleStack.addArrangedSubview(allergensTitle)
        
        let allergensStack = UIStackView()
        allergensStack.translatesAutoresizingMaskIntoConstraints = false
        allergensStack.axis = .vertical
        allergensStack.spacing = 4
        
        if self.babyMeal.allergens.isEmpty {
            let noAllergensLabel = UILabel()
            noAllergensLabel.text = "No Allergens"
            noAllergensLabel.font = UIFont.italicSystemFont(ofSize: 14)
            noAllergensLabel.textColor = .black
            allergensStack.addArrangedSubview(noAllergensLabel)
        } else {
            for allergen in self.babyMeal.allergens {
                let allergenLabel = UILabel()
                allergenLabel.text = "• \(allergen)"
                allergenLabel.textColor = .black
                allergensStack.addArrangedSubview(allergenLabel)
            }
        }
        
        allergensView.addSubview(allergensTitleStack)
        allergensView.addSubview(allergensStack)
        
        NSLayoutConstraint.activate([
            allergensView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            allergensView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            allergensView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            allergensTitleStack.topAnchor.constraint(equalTo: allergensView.topAnchor, constant: 8),
            allergensTitleStack.leadingAnchor.constraint(equalTo: allergensView.leadingAnchor, constant: 8),
            
            allergensStack.topAnchor.constraint(equalTo: allergensTitle.bottomAnchor, constant: 8),
            allergensStack.leadingAnchor.constraint(equalTo: allergensView.leadingAnchor, constant: 8),
            allergensStack.trailingAnchor.constraint(equalTo: allergensView.trailingAnchor, constant: -8),
            allergensStack.bottomAnchor.constraint(equalTo: allergensView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupRecipeInfo() {
        contentView.addSubview(recipeInfoLabel)
        recipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeInfoLabel.numberOfLines = 0
        
        let recipeInfoTitle = NSMutableAttributedString(string: "Recipe Information\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        let recipeInfoDetails = NSAttributedString(string: "Serving size: \(self.babyMeal.servingSize)\nEstimated cooking time: \(self.babyMeal.estimatedCookingTimeMinutes) mins")
        recipeInfoTitle.append(recipeInfoDetails)
        
        recipeInfoLabel.attributedText = recipeInfoTitle
        
        NSLayoutConstraint.activate([
            recipeInfoLabel.topAnchor.constraint(equalTo: allergensView.bottomAnchor, constant: 16),
            recipeInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupIngredients() {
        contentView.addSubview(ingredientsLabel)
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.numberOfLines = 0
        
        let ingredientsTitle = NSMutableAttributedString(string: "Ingredients\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        let ingredientsList = self.babyMeal.ingredients.map { "• \($0)" }.joined(separator: "\n")
        ingredientsTitle.append(NSAttributedString(string: ingredientsList))
        
        ingredientsLabel.attributedText = ingredientsTitle
        
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: recipeInfoLabel.bottomAnchor, constant: 16),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCookingInstructions() {
        contentView.addSubview(cookingInstructionsLabel)
        cookingInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        cookingInstructionsLabel.numberOfLines = 0
        
        let cookingInstructionsTitle = NSMutableAttributedString(string: "Cooking Instructions\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        cookingInstructionsTitle.append(NSAttributedString(string: self.babyMeal.cookingSteps))
        
        cookingInstructionsLabel.attributedText = cookingInstructionsTitle
        
        NSLayoutConstraint.activate([
            cookingInstructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            cookingInstructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cookingInstructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAddToCollectionButton() {
        contentView.addSubview(addToLogButton)
        addToLogButton.translatesAutoresizingMaskIntoConstraints = false
        
        addToLogButton.setTitle("Save to Collections", for: .normal)
        addToLogButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addToLogButton.setTitleColor(.white, for: .normal)
        addToLogButton.backgroundColor = .accent
        addToLogButton.layer.cornerRadius = 8
        addToLogButton.addTarget(self, action: #selector(addToCollectionTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addToLogButton.topAnchor.constraint(equalTo: cookingInstructionsLabel.bottomAnchor, constant: 24),
            addToLogButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToLogButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToLogButton.heightAnchor.constraint(equalToConstant: 44),
            addToLogButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupButtonIfSavedToCollection(){
        
    }
    
    @objc private func addToCollectionTapped() {
        #warning("Add to log button hasn't been implemented")
    }
}

extension BabyMealDetailUIView {
    func setIsAlreadySaved(status: Bool){
        self.isAlreadySaved = status
    }
}
