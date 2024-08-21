//
//  BulletListUILabel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import UIKit


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
