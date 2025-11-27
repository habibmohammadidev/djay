//
//  PageIndicatorView.swift
//  Djay
//

import UIKit

class PageIndicatorView: UIView {
    private var dotViews: [UIView] = []
    private let stackView = UIStackView()
    
    var numberOfPages: Int = 0 {
        didSet {
            setupDots()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateDots()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        addAutoLayoutSubview(stackView)
        
        [
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ].activate()
    }
    
    private func setupDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        for _ in 0..<numberOfPages {
            let dot = UIView()
            dot.backgroundColor = UIColor.whiteBase.withAlphaComponent(0.3)
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            
            [
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ].activate()
            
            stackView.addArrangedSubview(dot)
            dotViews.append(dot)
        }
        
        updateDots()
    }
    
    private func updateDots() {
        for (index, dot) in dotViews.enumerated() {
            let isActive = index == currentPage
            
            UIView.animate(withDuration: 0.3) {
                dot.backgroundColor = isActive 
                    ? UIColor.whiteBase
                    : UIColor.whiteBase.withAlphaComponent(0.3)
                dot.transform = isActive 
                    ? CGAffineTransform(scaleX: 1.2, y: 1.2)
                    : .identity
            }
        }
    }
}
