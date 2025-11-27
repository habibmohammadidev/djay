//
//  UIView+AutoLayout.swift
//  Djay
// TODO: Habib Remove all headers

import UIKit

extension UIView {
    static var isLandscape: Bool {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .interfaceOrientation
            .isLandscape ?? false
    }
    static var isPortrait: Bool { !isLandscape }
    var isLandscape: Bool { UIView.isLandscape }
    var isPortrait: Bool { UIView.isPortrait }
    
    func addAutoLayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
    
    func addAutoLayoutSubviews(_ subviews: UIView...) {
        subviews.forEach { addAutoLayoutSubview($0) }
    }
    
    func edgeConstraints(for subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ]
    }
}

extension UIViewController {
    var isLandscape: Bool { UIView.isLandscape }
    var isPortrait: Bool { UIView.isPortrait }
}

extension UILayoutGuide {
    func edgeConstraints(for subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ]
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }

    func deactivate() {
        forEach { $0.isActive = false }
    }
}
