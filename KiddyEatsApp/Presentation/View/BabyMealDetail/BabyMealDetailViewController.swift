import UIKit
import SwiftUI
import SwiftData


class BabyMealDetailViewController: UIViewController {
    private let viewModel: BabyMealDetailViewModel
    private var detailView: BabyMealDetailUIView!
    
    private var babyMeal: BabyMeal
    private var modelContext: ModelContext
    
    init(babyMeal: BabyMeal, modelContext: ModelContext) {
        self.viewModel = BabyMealDetailViewModel(
            saveBabyMealUseCase: SaveBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
            deleteBabyMealUseCase: DeleteBabyMealUseCase(repo: BabyMealRepositoryImpl.shared),
            getBabyMealUseCase: GetBabymealUseCase(repo: BabyMealRepositoryImpl.shared)
        )
        self.babyMeal = babyMeal
        self.modelContext = modelContext
        viewModel.checkIfAlreadyFavorite(modelContext: modelContext, babyMealID: babyMeal.id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .appBackground
        setupUI()
    }
    
    private func setupUI() {
        title = "Recipe Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        
        detailView = BabyMealDetailUIView(viewModel: viewModel, babyMeal: babyMeal, isAlreadySaved: viewModel.isFavorited)
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
