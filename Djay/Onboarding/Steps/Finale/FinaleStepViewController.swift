//
//  FinaleStepViewController.swift
//  Djay
//

import UIKit
import Combine

protocol AnyFinaleStepViewModel: AnyOnboardingStepViewModel {
    var title: String { get }
    var subtitle: String { get }
}
class FinaleStepViewController: UIViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    let viewModel: AnyFinaleStepViewModel
    
    init(viewModel: AnyFinaleStepViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        view.addAutoLayoutSubviews(imageView, titleLabel, subtitleLabel)
        (imageViewConstraints +
         titleLabelConstraints +
         subtitleLabelConstraints
        ).activate()
    }
    
    private func configure() {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

extension FinaleStepViewController: OnboardingTransitionable {
    var animatedViews: [UIView] { [imageView, titleLabel, subtitleLabel] }
}

extension FinaleStepViewController {
    private var imageViewConstraints: [NSLayoutConstraint] {
        [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120)
        ]
    }
    
    private var titleLabelConstraints: [NSLayoutConstraint] {
        [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20)
        ]
    }
    
    private var subtitleLabelConstraints: [NSLayoutConstraint] {
        [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20)
        ]
    }
}
