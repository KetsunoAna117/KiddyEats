//
//  NumberedListUILabel.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import UIKit


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
