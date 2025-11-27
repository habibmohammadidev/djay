//
//  HomeViewController.swift
//  Djay
//

import UIKit
import Combine

protocol AnyHomeViewModel {
    var frequency: Float { get set }
    var amplitude: Float { get set }
    var vibration: Float { get set }
    var frequencyPublisher: AnyPublisher<Float, Never> { get }
    var amplitudePublisher: AnyPublisher<Float, Never> { get }
    var vibrationPublisher: AnyPublisher<Float, Never> { get }
    var buttonTitlePublisher: AnyPublisher<String, Never> { get }
    func togglePlayback()
}

class HomeViewController: UIViewController {
    private let gradientBackground = GradientView()
    private let frequencyKnob = KnobControl(title: "Frequency")
    private let amplitudeKnob = KnobControl(title: "Amplitude")
    private let vibrationKnob = KnobControl(title: "Vibration")
    private let startStopButton = UIButton(type: .system)
    private var viewModel: AnyHomeViewModel
    private var bag = Set<AnyCancellable>()
    init(viewModel: AnyHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addAutoLayoutSubviews(gradientBackground, frequencyKnob, amplitudeKnob, vibrationKnob, startStopButton)
        
        frequencyKnob.minimumValue = 100
        frequencyKnob.maximumValue = 1000
        frequencyKnob.value = 440
        frequencyKnob.addTarget(self, action: #selector(frequencyChanged), for: .valueChanged)
        
        amplitudeKnob.minimumValue = 0
        amplitudeKnob.maximumValue = 1
        amplitudeKnob.value = 0.5
        amplitudeKnob.addTarget(self, action: #selector(amplitudeChanged), for: .valueChanged)
        
        vibrationKnob.minimumValue = 0
        vibrationKnob.maximumValue = 10
        vibrationKnob.value = 0
        vibrationKnob.addTarget(self, action: #selector(vibrationChanged), for: .valueChanged)
        
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        startStopButton.layer.cornerRadius = 25
        startStopButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            frequencyKnob.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            frequencyKnob.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            frequencyKnob.widthAnchor.constraint(equalToConstant: 80),
            frequencyKnob.heightAnchor.constraint(equalToConstant: 120),
            
            amplitudeKnob.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            amplitudeKnob.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amplitudeKnob.widthAnchor.constraint(equalToConstant: 80),
            amplitudeKnob.heightAnchor.constraint(equalToConstant: 120),
            
            vibrationKnob.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            vibrationKnob.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            vibrationKnob.widthAnchor.constraint(equalToConstant: 80),
            vibrationKnob.heightAnchor.constraint(equalToConstant: 120),
            
            startStopButton.topAnchor.constraint(equalTo: amplitudeKnob.bottomAnchor, constant: 60),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.widthAnchor.constraint(equalToConstant: 120),
            startStopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.frequencyPublisher
            .sink { [weak self] value in
                self?.frequencyKnob.updateValueLabel("\(Int(value)) Hz")
            }
            .store(in: &bag)
        
        viewModel.amplitudePublisher
            .sink { [weak self] value in
                self?.amplitudeKnob.updateValueLabel(String(format: "%.2f", value))
            }
            .store(in: &bag)
        
        viewModel.vibrationPublisher
            .sink { [weak self] value in
                self?.vibrationKnob.updateValueLabel(String(format: "%.1f Hz", value))
            }
            .store(in: &bag)
        viewModel.buttonTitlePublisher
            .sink { [weak self] title in
                self?.startStopButton.setTitle(title, for: .normal)
            }
            .store(in: &bag)
    }
    
    @objc private func frequencyChanged() {
        viewModel.frequency = frequencyKnob.value
    }
    
    @objc private func amplitudeChanged() {
        viewModel.amplitude = amplitudeKnob.value
    }
    
    @objc private func vibrationChanged() {
        viewModel.vibration = vibrationKnob.value
    }
    
    @objc private func togglePlayback() {
        viewModel.togglePlayback()
    }
}
