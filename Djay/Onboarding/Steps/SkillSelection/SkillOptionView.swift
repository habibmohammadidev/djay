//
//  SkillOptionView.swift
//  Djay
//

import UIKit

class SkillOptionView: UIView {
    private let titleLabel = UILabel()
    private let radioButton = UIView()
    private let radioInner = UIView()


    var isSelected: Bool = false { didSet { updateSelection(oldValue: oldValue) } }    
    var onTap: (() -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        radioButton.backgroundColor = .clear
        radioButton.layer.cornerRadius = 12
        radioButton.layer.borderWidth = 2
        radioButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        radioInner.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
        radioInner.layer.cornerRadius = 6
        radioInner.alpha = 0
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        addAutoLayoutSubviews(radioButton, radioInner, titleLabel)
        
        [
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
            
            radioInner.centerXAnchor.constraint(equalTo: radioButton.centerXAnchor),
            radioInner.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor),
            radioInner.widthAnchor.constraint(equalToConstant: 12),
            radioInner.heightAnchor.constraint(equalToConstant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ].activate()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    private func updateSelection(oldValue: Bool) {
        let shouldAnimate = oldValue != isSelected
        UIView.animate(withDuration: shouldAnimate && isSelected ? 0.3 : 0,
                       delay: 0,
                       usingSpringWithDamping: shouldAnimate ? 0.3 : 0,
                       initialSpringVelocity: shouldAnimate ? 0.1 : 0) {
            self.radioInner.alpha = self.isSelected ? 1 : 0
            self.radioInner.transform = self.isSelected ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.layer.borderColor = self.isSelected 
                ? UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
                : UIColor.white.withAlphaComponent(0.1).cgColor
            self.backgroundColor = self.isSelected
                ? UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 0.1)
                : UIColor.white.withAlphaComponent(0.05)
        }
    }
}
