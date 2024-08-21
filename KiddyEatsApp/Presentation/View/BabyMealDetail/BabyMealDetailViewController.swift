import UIKit
import SwiftUI
import SwiftUI

class EmojiUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont.systemFont(ofSize: 80)
        textAlignment = .center
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}

class TitleUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textColor = .label
        numberOfLines = 0
    }
}

class AllergensUIView: UIView {
    private let headerView: HeaderUIView
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        self.headerView = HeaderUIView(icon: UIImage(systemName: "exclamationmark.triangle"), title: "Possible Allergens", color: .label)
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = UIColor(named: "GreenSecondary")
        layer.cornerRadius = 8
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        addSubview(headerView)
        addSubview(stackView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func setAllergens(_ allergens: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if allergens.isEmpty {
            let noAllergensLabel = UILabel()
            noAllergensLabel.text = "No Allergens"
            noAllergensLabel.font = UIFont.italicSystemFont(ofSize: 14)
            noAllergensLabel.textColor = .label
            stackView.addArrangedSubview(noAllergensLabel)
        } else {
            for allergen in allergens {
                let allergenLabel = UILabel()
                allergenLabel.text = "• \(allergen)"
                allergenLabel.textColor = .label
                stackView.addArrangedSubview(allergenLabel)
            }
        }
    }
}

import SwiftUI

class SaveToCollectionsHostingController: UIHostingController<SaveToCollectionsButton> {
    var onHeightChange: ((CGFloat) -> Void)?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
        onHeightChange?(view.intrinsicContentSize.height)
    }
}

class HeaderUIView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    init(icon: UIImage?, title: String, color: UIColor) {
        super.init(frame: .zero)
        configure(icon: icon, title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(icon: UIImage?, title: String, color: UIColor) {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        iconImageView.image = icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = color
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = color
    }
}


class BulletListUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        numberOfLines = 0
    }
    
    func setItems(_ items: [String]) {
        let attributedString = NSMutableAttributedString()
        
        items.forEach { item in
            let bulletPoint = "• "
            let formattedString = "\(bulletPoint)\(item)\n"
            let attributedText = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 12
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.tailIndent = -12
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.paragraphSpacing = 0
            
            attributedText.addAttribute(.paragraphStyle, 
                                        value: paragraphStyle, 
                                        range: NSRange(location: 0, length: attributedText.length))
            
            attributedString.append(attributedText)
        }
        
        // Remove the last newline to reduce extra bottom spacing
        if let lastChar = attributedString.string.last, lastChar == "\n" {
            attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
        }
        
        self.attributedText = attributedString
    }
}

class NumberedListUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        numberOfLines = 0
    }
    
    func setItems(_ items: [String]) {
        let attributedString = NSMutableAttributedString()
        
        items.enumerated().forEach { index, item in
            let strippedItem = stripNumbering(from: item)
            let numberString = "\(index + 1). "
            let fullString = numberString + strippedItem
            
            let paragraphStyle = createParagraphStyle(firstLineHeadIndent: 0, headIndent: 18)
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 16)
            ]
            
            let attributedItem = NSAttributedString(string: fullString + "\n", attributes: attributes)
            attributedString.append(attributedItem)
        }
        
        self.attributedText = attributedString
    }
    
    private func stripNumbering(from item: String) -> String {
        let components = item.components(separatedBy: ". ")
        if components.count > 1, Int(components[0]) != nil {
            return components[1...].joined(separator: ". ")
        }
        return item
    }
    
    private func createParagraphStyle(firstLineHeadIndent: CGFloat, headIndent: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.paragraphSpacingBefore = 0
        return paragraphStyle
    }
}

class BabyMealDetailViewController: UIViewController {
    private let viewModel: BabyMealDetailViewModel
    private let scrollView = UIScrollView()
    
    private func color(named: String) -> UIColor {
        return UIColor(named: named) ?? .systemBackground
    }
    private let contentView = UIView()
    
    private let emojiLabel = EmojiUILabel()
    private let allergensView = AllergensUIView()
    private let recipeInfoLabel = BulletListUILabel()
    private let ingredientsLabel = BulletListUILabel()
    private let cookingInstructionsLabel = NumberedListUILabel()
    private var saveToCollectionsHostingController: SaveToCollectionsHostingController?
    
    private let recipeInfoHeader = HeaderUIView(icon: UIImage(systemName: "info.square"), title: "Recipe Information", color: .label)
    private let ingredientsHeader = HeaderUIView(icon: UIImage(systemName: "note.text"), title: "Ingredients", color: .label)
    private let cookingInstructionsHeader = HeaderUIView(icon: UIImage(systemName: "frying.pan"), title: "Cooking Instructions", color: .label)
    
    private var babyMeal: BabyMeal
    
    init(babyMeal: BabyMeal) {
        self.viewModel = BabyMealDetailViewModel(
            saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
            deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
            getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
        )
        self.babyMeal = babyMeal
        super.init(nibName: nil, bundle: nil)
        self.title = babyMeal.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color(named: "AppBackgroundColor")
        setupUI()
    }
    
    private func setupUI() {
        setupScrollView()
        setupEmojiLabel()
        setupAllergensView()
        setupRecipeInfoHeader()
        setupRecipeInfoLabel()
        setupIngredientsHeader()
        setupIngredientsLabel()
        setupCookingInstructionsHeader()
        setupCookingInstructionsLabel()
        setupSaveToCollectionsButton()
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
        emojiLabel.text = babyMeal.emoji
        
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
        allergensView.setAllergens(babyMeal.allergens)
        
        NSLayoutConstraint.activate([
            allergensView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 16),
            allergensView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            allergensView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupRecipeInfoHeader() {
        contentView.addSubview(recipeInfoHeader)
        recipeInfoHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeInfoHeader.topAnchor.constraint(equalTo: allergensView.bottomAnchor, constant: 24),
            recipeInfoHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeInfoHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupRecipeInfoLabel() {
        contentView.addSubview(recipeInfoLabel)
        recipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        let recipeInfoItems = [
            "Serving size: \(babyMeal.servingSize)",
            "Estimated cooking time: \(babyMeal.estimatedCookingTimeMinutes) mins"
        ]
        recipeInfoLabel.setItems(recipeInfoItems)
        
        NSLayoutConstraint.activate([
            recipeInfoLabel.topAnchor.constraint(equalTo: recipeInfoHeader.bottomAnchor, constant: 8),
            recipeInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            recipeInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupIngredientsHeader() {
        contentView.addSubview(ingredientsHeader)
        ingredientsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientsHeader.topAnchor.constraint(equalTo: recipeInfoLabel.bottomAnchor, constant: 24),
            ingredientsHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupIngredientsLabel() {
        contentView.addSubview(ingredientsLabel)
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.setItems(babyMeal.ingredients)
        
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsHeader.bottomAnchor, constant: 8),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCookingInstructionsHeader() {
        contentView.addSubview(cookingInstructionsHeader)
        cookingInstructionsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cookingInstructionsHeader.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 24),
            cookingInstructionsHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cookingInstructionsHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCookingInstructionsLabel() {
        contentView.addSubview(cookingInstructionsLabel)
        cookingInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        cookingInstructionsLabel.setItems(babyMeal.cookingSteps.components(separatedBy: "\n"))
        
        NSLayoutConstraint.activate([
            cookingInstructionsLabel.topAnchor.constraint(equalTo: cookingInstructionsHeader.bottomAnchor, constant: 8),
            cookingInstructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cookingInstructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSaveToCollectionsButton() {
        let saveToCollectionsButton = SaveToCollectionsButton(babyMeal: babyMeal)
        saveToCollectionsHostingController = SaveToCollectionsHostingController(rootView: saveToCollectionsButton)
        
        if let hostingView = saveToCollectionsHostingController?.view {
            contentView.addSubview(hostingView)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: cookingInstructionsLabel.bottomAnchor, constant: 16),
                hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
            
            saveToCollectionsHostingController?.onHeightChange = { [weak self] height in
                hostingView.heightAnchor.constraint(equalToConstant: height).isActive = true
                self?.view.layoutIfNeeded()
            }
        }
        
        addChild(saveToCollectionsHostingController!)
        saveToCollectionsHostingController?.didMove(toParent: self)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

#Preview {
    BabyMealDetailVCRepresentable()
}
