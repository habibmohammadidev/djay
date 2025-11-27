//
//  KnobControl.swift
//  Djay
//

import UIKit

class KnobControl: UIControl {
    var value: Float = 0.5 {
        didSet { setNeedsDisplay() }
    }
    var minimumValue: Float = 0.0
    var maximumValue: Float = 1.0
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private var lastAngle: CGFloat = 0
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        backgroundColor = .clear
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        valueLabel.font = .systemFont(ofSize: 12, weight: .regular)
        valueLabel.textColor = .white.withAlphaComponent(0.8)
        valueLabel.textAlignment = .center
        
        addAutoLayoutSubviews(titleLabel, valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let knobRect = CGRect(x: rect.midX - 40, y: rect.midY - 40, width: 80, height: 80)
        let center = CGPoint(x: knobRect.midX, y: knobRect.midY)
        let radius: CGFloat = 35
        
        let context = UIGraphicsGetCurrentContext()
        
        // Background circle
        context?.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        context?.fillEllipse(in: knobRect)
        
        // Value arc
        let startAngle = CGFloat.pi * 0.75
        let endAngle = CGFloat.pi * 2.25
        let valueAngle = startAngle + (endAngle - startAngle) * CGFloat((value - minimumValue) / (maximumValue - minimumValue))
        
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(4)
        context?.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: valueAngle, clockwise: false)
        context?.strokePath()
        
        // Indicator
        let indicatorX = center.x + cos(valueAngle) * (radius - 10)
        let indicatorY = center.y + sin(valueAngle) * (radius - 10)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillEllipse(in: CGRect(x: indicatorX - 4, y: indicatorY - 4, width: 8, height: 8))
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        lastAngle = angleForPoint(point)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let angle = angleForPoint(point)
        
        var delta = angle - lastAngle
        if delta > .pi { delta -= 2 * .pi }
        if delta < -.pi { delta += 2 * .pi }
        
        let range = maximumValue - minimumValue
        let change = Float(delta / (1.5 * .pi)) * range
        value = max(minimumValue, min(maximumValue, value + change))
        
        lastAngle = angle
        sendActions(for: .valueChanged)
        return true
    }
    
    private func angleForPoint(_ point: CGPoint) -> CGFloat {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        return atan2(point.y - center.y, point.x - center.x)
    }
    
    func updateValueLabel(_ text: String) {
        valueLabel.text = text
    }
}
