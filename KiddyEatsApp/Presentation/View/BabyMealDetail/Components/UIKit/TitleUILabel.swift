//
//  TitleUILabel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import UIKit


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
