//
//  OnboardingTransitionable.swift
//  Djay
//

import UIKit

protocol OnboardingTransitionable {
    var animatedViews: [UIView] { get }
    var continueButton: OnboardingButton { get }
}

extension OnboardingTransitionable {
    func animateTransition() {
        UIView.animateSlideIn(views: animatedViews, offset: 50)
    }
    
    func continueButtonConstraints(inView view: UIView) -> [NSLayoutConstraint] {
        [
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            continueButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 44)
        ]
    }
}
