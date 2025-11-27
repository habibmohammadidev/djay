//
//  OnboardingButton.swift
//  Djay
//

import UIKit

class OnboardingButton: UIButton {
    private static let tapScale: CGFloat = 0.98
    private static let enabledScale: CGFloat = 1.05
    
    init() {
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .buttonTitle
        config.baseForegroundColor = .textPrimary
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        configuration = config
        configurationUpdateHandler = { button in
            var config = button.configuration
            config?.baseBackgroundColor = button.isEnabled 
                ? .primaryBlue
                : .primaryBlueDisabled
            config?.baseForegroundColor = button.isEnabled
                ? .buttonTitle
                : .textDisabled
            button.configuration = config
        }
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    func setTitle(_ title: String) {
        guard var config = configuration else { return }
        var titleAttr = AttributedString(title)
        titleAttr.font = .sfProTextSemiBold(size: 17)
        config.attributedTitle = titleAttr
        configuration = config
    }
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: Self.tapScale, y: Self.tapScale)
        }
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
    
    func animateEnabled() {
        transform = CGAffineTransform(scaleX: Self.enabledScale, y: Self.enabledScale)
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
            self.transform = .identity
        }
    }
}
