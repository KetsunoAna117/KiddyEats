//
//  TestMealDetailViewController.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 21/08/24.
//

import UIKit
import SwiftUI


class TestMealDetailViewController: UIViewController {	

	let button = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureMarkAllergic()
	}
	
	// Go back to SwiftUI View
	@objc
	private func markAllergic() {
		let collectionView = CollectionView()
		let hostingController = UIHostingController(rootView: collectionView)
		navigationController?.popViewController(animated: true)
	}
	
	func configureMarkAllergic() {
		// Add button to the view hierarchy
		view.addSubview(button)
		
		// Disable autoresizing mask translation
		button.translatesAutoresizingMaskIntoConstraints = false
		
		// Configure button appearance
		button.setTitle("Mark Allergic", for: .normal)
		button.backgroundColor = .systemBlue
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 8
		
		// Add target for button tap
		button.addTarget(self, action: #selector(markAllergic), for: .touchUpInside)
		
		// Add constraints to position the button
		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			button.widthAnchor.constraint(equalToConstant: 200),
			button.heightAnchor.constraint(equalToConstant: 50)
		])
	}
}

