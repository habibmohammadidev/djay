//
//  OnboardingPageTransition.swift
//  Djay
//

import UIKit

class OnboardingPageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var toViewController: AnyOnboardingStepView?
    
    func prepareTransition(to viewController: AnyOnboardingStepView) {
        toViewController = viewController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? AnyOnboardingStepView,
              let toVC = transitionContext.viewController(forKey: .to) as? AnyOnboardingStepView else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        toVC.prepareForEnter(in: containerView)
        containerView.addSubview(toVC.view)
        toVC.view.frame = containerView.bounds
        
        fromVC.animateExit {}
        
        toVC.animateEnter {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
