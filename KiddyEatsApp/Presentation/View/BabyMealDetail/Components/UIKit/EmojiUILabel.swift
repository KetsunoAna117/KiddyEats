//
//  EmojiUILabel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import UIKit

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
