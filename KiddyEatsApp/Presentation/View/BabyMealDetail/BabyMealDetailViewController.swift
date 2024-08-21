import UIKit
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
        backgroundColor = .systemGray6
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
        self.headerView = HeaderUIView(icon: UIImage(systemName: "exclamationmark.triangle"), title: "Possible Allergens", color: .white)
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemRed
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
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
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
            noAllergensLabel.textColor = .white
            stackView.addArrangedSubview(noAllergensLabel)
        } else {
            for allergen in allergens {
                let allergenLabel = UILabel()
                allergenLabel.text = "• \(allergen)"
                allergenLabel.textColor = .white
                stackView.addArrangedSubview(allergenLabel)
            }
        }
    }
}

class AddToLogUIButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitle("Add to Log", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 8
    }
}

class HeaderUIView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    init(icon: UIImage?, title: String, color: UIColor = .label) {
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
            paragraphStyle.headIndent = 15
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.tailIndent = -15
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            attributedText.addAttribute(.paragraphStyle, 
                                        value: paragraphStyle, 
                                        range: NSRange(location: 0, length: attributedText.length))
            
            attributedString.append(attributedText)
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
            
            let paragraphStyle = createParagraphStyle(firstLineHeadIndent: 0, headIndent: 20)
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
        paragraphStyle.paragraphSpacingBefore = 4
        return paragraphStyle
    }
}

class BabyMealDetailViewController: UIViewController {
    private let viewModel: BabyMealDetailViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let emojiLabel = EmojiUILabel()
    private let titleLabel = TitleUILabel()
    private let allergensView = AllergensUIView()
    private let recipeInfoLabel = BulletListUILabel()
    private let ingredientsLabel = BulletListUILabel()
    private let cookingInstructionsLabel = NumberedListUILabel()
    private let addToLogButton = AddToLogUIButton()
    
    private let recipeInfoHeader = HeaderUIView(icon: UIImage(systemName: "info.circle"), title: "Recipe Information", color: .label)
    private let ingredientsHeader = HeaderUIView(icon: UIImage(systemName: "list.bullet"), title: "Ingredients", color: .label)
    private let cookingInstructionsHeader = HeaderUIView(icon: UIImage(systemName: "text.book.closed"), title: "Cooking Instructions", color: .label)
    
    private var babyMeal: BabyMeal
    
    init(babyMeal: BabyMeal) {
        self.viewModel = BabyMealDetailViewModel(
            saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
            deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
            getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
        )
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
        setupTitleLabel()
        setupAllergensView()
        setupRecipeInfoHeader()
        setupRecipeInfoLabel()
        setupIngredientsHeader()
        setupIngredientsLabel()
        setupCookingInstructionsHeader()
        setupCookingInstructionsLabel()
        setupAddToLogButton()
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
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = babyMeal.name
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAllergensView() {
        contentView.addSubview(allergensView)
        allergensView.translatesAutoresizingMaskIntoConstraints = false
        allergensView.setAllergens(babyMeal.allergens)
        
        NSLayoutConstraint.activate([
            allergensView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
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
            recipeInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
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
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
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
            cookingInstructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cookingInstructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAddToLogButton() {
        contentView.addSubview(addToLogButton)
        addToLogButton.translatesAutoresizingMaskIntoConstraints = false
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
        // Implement the logic for adding the meal to the log
    }
}

#Preview {
    BabyMealDetailVCRepresentable()
}
