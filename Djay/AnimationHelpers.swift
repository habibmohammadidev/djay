import UIKit

extension UIView {
    static func animateStaggered(
        views: [UIView],
        duration: TimeInterval = 0.4,
        staggerDelay: TimeInterval = 0.05,
        options: UIView.AnimationOptions = [.curveEaseOut],
        animations: @escaping (UIView) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let group = DispatchGroup()
        
        for (index, view) in views.enumerated() {
            group.enter()
            let delay = TimeInterval(index) * staggerDelay
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                animations(view)
            } completion: { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
    
    static func animateSlideIn(
        views: [UIView],
        offset: CGFloat = 50,
        duration: TimeInterval = 0.4,
        staggerDelay: TimeInterval = 0.05,
        completion: (() -> Void)? = nil
    ) {
        views.forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: offset, y: 0)
        }
        
        animateStaggered(views: views, duration: duration, staggerDelay: staggerDelay) { view in
            view.alpha = 1
            view.transform = .identity
        } completion: {
            completion?()
        }
    }
    
    static func animateSlideOut(
        views: [UIView],
        offset: CGFloat = -50,
        duration: TimeInterval = 0.4,
        staggerDelay: TimeInterval = 0.05,
        completion: (() -> Void)? = nil
    ) {
        animateStaggered(views: views, duration: duration, staggerDelay: staggerDelay) { view in
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: offset, y: 0)
        } completion: {
            views.forEach {
                $0.alpha = 1
                $0.transform = .identity
            }
            completion?()
        }
    }
}
