//
//  MainViewController.swift
//  Djay
//

import UIKit

class MainViewController: UIViewController {
    private let gradientBackground = GradientView()
    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addAutoLayoutSubviews(gradientBackground, iconImageView, welcomeLabel, subtitleLabel)
        
        iconImageView.image = UIImage(systemName: "music.note.house.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        welcomeLabel.text = "Welcome to Djay"
        welcomeLabel.font = .systemFont(ofSize: 34, weight: .bold)
        welcomeLabel.textColor = .white
        welcomeLabel.textAlignment = .center
        
        subtitleLabel.text = "Your music journey starts here"
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            welcomeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}
