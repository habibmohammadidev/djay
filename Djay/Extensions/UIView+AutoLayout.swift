//
//  UIView+AutoLayout.swift
//  Djay
//

import UIKit

extension UIView {
    func addAutoLayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
    
    func addAutoLayoutSubviews(_ subviews: [UIView]) {
        subviews.forEach { addAutoLayoutSubview($0) }
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}
