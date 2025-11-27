//
//  FadeNavigationTransition.swift
//  Djay
//

import UIKit

class FadeNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        toView.alpha = 0
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

class FadeNavigationDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeNavigationTransition()
    }
}
