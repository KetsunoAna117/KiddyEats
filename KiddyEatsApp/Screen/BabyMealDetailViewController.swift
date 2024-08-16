import UIKit
import SwiftUI

class BabyMealDetailViewController: UIViewController {
    private let babyMeal: BabyMeal
    private var isFavorite: Bool = false
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let allergensView = UIView()
    private let recipeInfoLabel = UILabel()
    private let ingredientsLabel = UILabel()
    private let cookingInstructionsLabel = UILabel()
    private let addToLogButton = UIButton(type: .system)
    
    init(babyMeal: BabyMeal) {
        self.babyMeal = babyMeal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Recipe Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        
        setupScrollView()
        setupEmojiLabel()
        setupTitle()
        setupAllergensView()
        setupRecipeInfo()
        setupIngredients()
        setupCookingInstructions()
        setupAddToLogButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
        emojiLabel.text = babyMeal.emoji
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
        
        titleLabel.text = babyMeal.name
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
        allergensView.backgroundColor = .systemRed
        allergensView.layer.cornerRadius = 8
        
        let allergensTitle = UILabel()
        allergensTitle.text = "Possible Allergens"
        allergensTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        allergensTitle.textColor = .white
        
        let allergensStack = UIStackView()
        allergensStack.axis = .vertical
        allergensStack.spacing = 4
        
        for allergen in babyMeal.allergens {
            let allergenLabel = UILabel()
            allergenLabel.text = "• \(allergen)"
            allergenLabel.textColor = .white
            allergensStack.addArrangedSubview(allergenLabel)
        }
        
        allergensView.addSubview(allergensTitle)
        allergensView.addSubview(allergensStack)
        
        allergensTitle.translatesAutoresizingMaskIntoConstraints = false
        allergensStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allergensView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            allergensView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            allergensView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            allergensTitle.topAnchor.constraint(equalTo: allergensView.topAnchor, constant: 8),
            allergensTitle.leadingAnchor.constraint(equalTo: allergensView.leadingAnchor, constant: 8),
            allergensTitle.trailingAnchor.constraint(equalTo: allergensView.trailingAnchor, constant: -8),
            
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
        let recipeInfoDetails = NSAttributedString(string: "Serving size: \(babyMeal.servingSize)\nEstimated cooking time: \(babyMeal.estimatedCookingTimeMinutes) mins")
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
        let ingredientsList = babyMeal.ingredients.map { "• \($0)" }.joined(separator: "\n")
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
        cookingInstructionsTitle.append(NSAttributedString(string: babyMeal.cookingSteps))
        
        cookingInstructionsLabel.attributedText = cookingInstructionsTitle
        
        NSLayoutConstraint.activate([
            cookingInstructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            cookingInstructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cookingInstructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAddToLogButton() {
        contentView.addSubview(addToLogButton)
        addToLogButton.translatesAutoresizingMaskIntoConstraints = false
        
        addToLogButton.setTitle("Add to Log", for: .normal)
        addToLogButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addToLogButton.setTitleColor(.white, for: .normal)
        addToLogButton.backgroundColor = .accentColor
        addToLogButton.layer.cornerRadius = 8
        addToLogButton.addTarget(self, action: #selector(addToLogTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addToLogButton.topAnchor.constraint(equalTo: cookingInstructionsLabel.bottomAnchor, constant: 24),
            addToLogButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToLogButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToLogButton.heightAnchor.constraint(equalToConstant: 44),
            addToLogButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addToLogTapped() {
        // Implement add to log functionality
        print("Add to log tapped")
    }
}

// MARK: - SwiftUI Preview
struct BabyMealDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        BabyMealDetailVCRepresentable()
    }
}

struct BabyMealDetailVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BabyMealDetailViewController {
        let sampleMeal = BabyMeal(
            name: "Sweet Potato Puree",
            emoji: "🍠",
            ingredients: ["1 medium sweet potato", "2 tablespoons breast milk or formula"],
            allergens: ["Milk"],
            cookingSteps: "1. Wash and peel the sweet potato.\n2. Cut into small cubes.\n3. Steam until soft, about 15 minutes.\n4. Mash or puree the sweet potato.\n5. Add breast milk or formula to achieve desired consistency.",
            servingSize: 2,
            estimatedCookingTimeMinutes: 20
        )
        return BabyMealDetailViewController(babyMeal: sampleMeal)
    }
    
    func updateUIViewController(_ uiViewController: BabyMealDetailViewController, context: Context) {}
}
