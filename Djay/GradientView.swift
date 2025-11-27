//
//  GradientView.swift
//  Djay
//
//  Created by Habibollah Mohammadi on 20.11.25.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    override class var layerClass: AnyClass { CAGradientLayer.self }
    private var gradientLayerInstance: CAGradientLayer { layer as! CAGradientLayer }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateColors()
    }

    private func updatePoints() {
    
        gradientLayerInstance.startPoint = CGPoint(x: 0.5, y: 0.0) // top center
        gradientLayerInstance.endPoint = CGPoint(x: 0.5, y: 1.0) // bottom center
    }

    private func updateColors() {
        gradientLayerInstance.colors = [
            UIColor.gradientBackgroundTop.cgColor,
            UIColor.gradientBackgroundBottom.cgColor
        ]
    }
}

