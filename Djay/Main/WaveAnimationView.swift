//
//  WaveAnimationView.swift
//  Djay
//

import UIKit

class WaveAnimationView: UIView {
    private let waveLayer = CAShapeLayer()
    private var displayLink: CADisplayLink?
    private var phase: CGFloat = 0
    
    var frequency: CGFloat = 440 { didSet { setNeedsDisplay() } }
    var amplitude: CGFloat = 0.5 { didSet { setNeedsDisplay() } }
    var vibration: CGFloat = 0 { didSet { setNeedsDisplay() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        waveLayer.strokeColor = UIColor.white.withAlphaComponent(0.6).cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 3
        layer.addSublayer(waveLayer)
    }
    
    func startAnimating() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateWave() {
        phase += 0.05 + (vibration * 0.02)
        drawWave()
    }
    
    private func drawWave() {
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        let midY = height / 2
        let waveHeight = midY * amplitude * 0.8
        let wavelength = width / (frequency / 200)
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        for x in stride(from: 0, through: width, by: 2) {
            let relativeX = x / wavelength
            let y = sin((relativeX + phase) * .pi * 2) * waveHeight + midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        waveLayer.path = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        waveLayer.frame = bounds
    }
}
