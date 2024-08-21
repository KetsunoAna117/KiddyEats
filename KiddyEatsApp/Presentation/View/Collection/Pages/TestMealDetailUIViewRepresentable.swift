//
//  TestMealDetailUIViewRepresentable.swift
//  KiddyEatsApp
//
//  Created by Gusti Rizky Fajar on 21/08/24.
//

import SwiftUI

struct TestMealDetailUIViewControllerRepresentable: UIViewControllerRepresentable {	
	func makeUIViewController(context: Context) -> TestMealDetailViewController {
		return TestMealDetailViewController()
	}
	
	func updateUIViewController(_ uiViewController: TestMealDetailViewController, context: Context) {}
}
