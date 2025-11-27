//
//  OnboardingTransitionable.swift
//  Djay
//

import UIKit

protocol OnboardingTransitionable {
    var animatedViews: [UIView] { get }
    func prepareForEnter(in containerView: UIView)
    func animateEnter(oldView: UIView?, completion: @escaping () -> Void)
    func animateExit(completion: @escaping () -> Void)
}

extension OnboardingTransitionable where Self: UIViewController {
    func prepareForEnter(in containerView: UIView) {
        animatedViews.forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 50, y: 0)
        }
    }
    
    func animateEnter(oldView: UIView?, completion: @escaping () -> Void) {
        view.layoutIfNeeded()
        UIView.animateSlideIn(views: animatedViews, offset: 50) {
            completion()
        }
    }
    
    func animateExit(completion: @escaping () -> Void) {
        UIView.animateSlideOut(views: animatedViews, offset: -50) {
            completion()
        }
    }
}
