    //
//  AllergensUIView.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import UIKit


class ReactionsUIView: UIView {
    private let headerView: HeaderUIView
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        self.headerView = HeaderUIView(icon: UIImage(systemName: "exclamationmark.triangle"), title: "Reaction Summary", color: .label)
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
    
    func setReactions(_ reactions: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if reactions.isEmpty {
            let noReactionsLabel = UILabel()
            noReactionsLabel.text = "No reactions recorded"
            noReactionsLabel.font = UIFont.italicSystemFont(ofSize: 14)
            noReactionsLabel.textColor = .label
            stackView.addArrangedSubview(noReactionsLabel)
        } else {
            for reaction in reactions {
                let reactionLabel = UILabel()
                reactionLabel.text = "• \(reaction)"
                reactionLabel.textColor = .label
                stackView.addArrangedSubview(reactionLabel)
            }
        }
    }
}
