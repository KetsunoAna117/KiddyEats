import UIKit
import SwiftUI


class BabyMealDetailViewController: UIViewController {
    
    private let babyMealVmd = BabyMealDetailDelegateViewModel(
        saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
        getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
    )    

    private let scrollView = UIScrollView()
    private var isReactionsVisible = true
    
    private func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func color(named: String) -> UIColor {
        return UIColor(named: named) ?? .systemBackground
    }
    private let contentView = UIView()
    private let emojiLabel = EmojiUILabel()
    private let allergensView = AllergensUIView()
    private let reactionsView = ReactionsUIView()
    private let recipeInfoLabel = BulletListUILabel()
    private let ingredientsLabel = BulletListUILabel()
    private let cookingInstructionsLabel = NumberedListUILabel()
    
    private var afterInit = 0
    
    private lazy var logReactionHostingController: SwiftUIButtonController = {
        let logReactionButton = AnyView(LogReactionButton(babyMeal: self.babyMealVmd.babyMeal, vmd: self.babyMealVmd))
        return SwiftUIButtonController(rootView: logReactionButton)
    }()
    
    private lazy var saveToCollectionsHostingController: SwiftUIButtonController = {
        let saveToCollectionsButton = AnyView(
            MealDetailSaveToCollectionsButton(babyMeal: self.babyMealVmd.babyMeal, vmd: self.babyMealVmd)
        )
        return SwiftUIButtonController(rootView: saveToCollectionsButton)
    }()
    private let recipeInfoHeader = HeaderUIView(icon: UIImage(systemName: "info.square"), title: "Recipe Information", color: .label)
    private let ingredientsHeader = HeaderUIView(icon: UIImage(systemName: "note.text"), title: "Ingredients", color: .label)
    private let cookingInstructionsHeader = HeaderUIView(icon: UIImage(systemName: "frying.pan"), title: "Cooking Instructions", color: .label)
    
    init(babyMeal: BabyMeal) {
        super.init(nibName: nil, bundle: nil)
        self.babyMealVmd.babyMeal = babyMeal
        self.title = self.babyMealVmd.babyMeal.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        updateButtonsBasedOnFavoritedStatus()
    }
    
    private func setupUI() {
        setupScrollView()
        setupEmojiLabel()
        setupAllergensView()
        setupReactionsView()
        setupRecipeInfoHeader()
        setupRecipeInfoLabel()
        setupIngredientsHeader()
        setupIngredientsLabel()
        setupCookingInstructionsHeader()
        setupCookingInstructionsLabel()
        setupButtons()
        setupBinds()
        updateButtonsBasedOnFavoritedStatus()
    }
    
    private func setupBinds() {
        babyMealVmd.reactionsDidChange = { [weak self] updatedReaction in
            print("New reaction in VC: \(updatedReaction)")
            guard let self = self else {
                return
            }
            self.babyMealVmd.babyMeal.reactionList = updatedReaction
            self.reactionsView.setReactions(updatedReaction)
        }
        
        babyMealVmd.isFavoritedDidChange = { [weak self] isFavorited in
            guard let self = self else { return }
            
            if isFavorited {
                showAddToLogButton()
                if afterInit >= 2 {
                    scrollToBottom()
                }
                afterInit += 1
            } else {
                hideAddToLogButton()
            }
        }
    }
    
    private func updateButtonsBasedOnFavoritedStatus() {
        print("isFavorited status: \(babyMealVmd.isFavorited)")
        // Always show the Log Reaction button
        showAddToLogButton()
        
        if babyMealVmd.isFavorited {
            scrollToBottom()
        }
    }
    
    private func setupReactionsView() {
        contentView.addSubview(reactionsView)
        reactionsView.translatesAutoresizingMaskIntoConstraints = false
        reactionsView.setReactions(self.babyMealVmd.babyMeal.reactionList)
        
        NSLayoutConstraint.activate([
            reactionsView.topAnchor.constraint(equalTo: allergensView.bottomAnchor, constant: 0),
            reactionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reactionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        reactionsView.isHidden = false
    }
    
    private func areReactionsEmpty() -> Bool {
        return self.babyMealVmd.babyMeal.reactionList.isEmpty
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        emojiLabel.text = self.babyMealVmd.babyMeal.emoji
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 100),
            emojiLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupAllergensView() {
        contentView.addSubview(allergensView)
        allergensView.translatesAutoresizingMaskIntoConstraints = false
        allergensView.setAllergens(self.babyMealVmd.babyMeal.allergens)
        
        setupHorizontalConstraints(for: allergensView, topAnchor: emojiLabel.bottomAnchor, topConstant: 16)
    }
    
    private func setupRecipeInfoHeader() {
        contentView.addSubview(recipeInfoHeader)
        recipeInfoHeader.translatesAutoresizingMaskIntoConstraints = false
        
        setupHorizontalConstraints(for: recipeInfoHeader, topAnchor: reactionsView.bottomAnchor, topConstant: 24)
    }
    
    private func setupRecipeInfoLabel() {
        contentView.addSubview(recipeInfoLabel)
        recipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        let recipeInfoItems = [
            "Serving size: \(self.babyMealVmd.babyMeal.servingSize)",
            "Estimated cooking time: \(self.babyMealVmd.babyMeal.estimatedCookingTimeMinutes) mins"
        ]
        recipeInfoLabel.setItems(recipeInfoItems)
        
        setupHorizontalConstraints(for: recipeInfoLabel, topAnchor: recipeInfoHeader.bottomAnchor, topConstant: 8, leadingConstant: 24)
    }
    
    private func setupIngredientsHeader() {
        contentView.addSubview(ingredientsHeader)
        ingredientsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        setupHorizontalConstraints(for: ingredientsHeader, topAnchor: recipeInfoLabel.bottomAnchor, topConstant: 24)
    }
    
    private func setupIngredientsLabel() {
        contentView.addSubview(ingredientsLabel)
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.setItems(self.babyMealVmd.babyMeal.ingredients)
        
        setupHorizontalConstraints(for: ingredientsLabel, topAnchor: ingredientsHeader.bottomAnchor, topConstant: 8, leadingConstant: 24)
    }
    
    private func setupCookingInstructionsHeader() {
        contentView.addSubview(cookingInstructionsHeader)
        cookingInstructionsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        setupHorizontalConstraints(for: cookingInstructionsHeader, topAnchor: ingredientsLabel.bottomAnchor, topConstant: 24)
    }
    
    private func setupCookingInstructionsLabel() {
        contentView.addSubview(cookingInstructionsLabel)
        cookingInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        cookingInstructionsLabel.setItems(self.babyMealVmd.babyMeal.cookingSteps.components(separatedBy: "\n"))
        
        setupHorizontalConstraints(for: cookingInstructionsLabel, topAnchor: cookingInstructionsHeader.bottomAnchor, topConstant: 8, leadingConstant: 24)
    }
    
    private func setupButtons() {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 8
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(buttonsStackView)
        
        // Add Log Reaction button
        addChild(logReactionHostingController)
        buttonsStackView.addArrangedSubview(logReactionHostingController.view)
        logReactionHostingController.didMove(toParent: self)
        logReactionHostingController.view.isHidden = false  // Ensure it's visible by default
        
        // Add Save to Collections button
        addChild(saveToCollectionsHostingController)
        buttonsStackView.addArrangedSubview(saveToCollectionsHostingController.view)
        saveToCollectionsHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonsStackView.topAnchor.constraint(equalTo: cookingInstructionsLabel.bottomAnchor, constant: 24),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        // Ensure buttons are visible
        updateButtonsBasedOnFavoritedStatus()
    }
    
    private func hideAddToLogButton() {
        logReactionHostingController.view.isHidden = true
    }
    
    private func showAddToLogButton() {
        logReactionHostingController.view.isHidden = false
    }
    
    private func setupHorizontalConstraints(for view: UIView, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat, leadingConstant: CGFloat = 16, trailingConstant: CGFloat = -16, bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingConstant),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingConstant)
        ])
        
        if let bottomAnchor = bottomAnchor {
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant).isActive = true
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

#Preview {
    BabyMealDetailVCRepresentable()
        .modelContainer(ModelContextManager.createModelContainer())
}
