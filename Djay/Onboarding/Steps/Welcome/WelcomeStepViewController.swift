//
//  WelcomeStepViewController.swift
//  Djay
//

import UIKit
import Combine

protocol AnyWelcomeStepViewModel: AnyOnboardingStepViewModel {
    var welcomeText: String { get }
}

class WelcomeStepViewController: UIViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    let logoContainerView = UIView()
    let continueButton = OnboardingButton()
    let viewModel: AnyWelcomeStepViewModel
    
    private var imageHeightConstraint: NSLayoutConstraint?
    private var titleBottomConstraint: NSLayoutConstraint?
    private var titleLeadingConstraint: NSLayoutConstraint?
    private var titleTrailingConstraint: NSLayoutConstraint?
    private var bag: AnyCancellable?
    
    init(viewModel: AnyWelcomeStepViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(for: size)
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "DjayLogo")
        
        logoContainerView.addAutoLayoutSubview(imageView)
        
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .textPrimary
        titleLabel.font = .sfProDisplayRegular(size: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.welcomeText
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        logoContainerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        bag = viewModel.buttonTitle
            .sink { [weak self] title in self?.continueButton.setTitle(title) }
        
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        view.addAutoLayoutSubviews(logoContainerView, titleLabel, continueButton)
        setupConstraints()
    }
    
    @objc private func handleContinue() {
        viewModel.handleContinue()
    }
}

extension WelcomeStepViewController: OnboardingTransitionable {
    var animatedViews: [UIView] { [logoContainerView, titleLabel, continueButton] }
}

extension WelcomeStepViewController {
    private enum LayoutConstants {
        enum Horizontal {
            static let imageHeight: CGFloat = 64
            static let titleBottomSpacing: CGFloat = 26
            static let horizontalPadding: CGFloat = 20
        }
        
        enum Vertical {
            static let imageHeight: CGFloat = 80
            static let titleBottomSpacing: CGFloat = 40
            static let horizontalPadding: CGFloat = 32
        }
    }
    
    private func setupConstraints() {
        let height = isPortrait ? LayoutConstants.Vertical.imageHeight : LayoutConstants.Horizontal.imageHeight
        let bottomSpacing = isPortrait ? LayoutConstants.Vertical.titleBottomSpacing : LayoutConstants.Horizontal.titleBottomSpacing
        let padding = isPortrait ? LayoutConstants.Vertical.horizontalPadding : LayoutConstants.Horizontal.horizontalPadding
        
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: height)
        titleBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -bottomSpacing)
        titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: padding)
        titleTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -padding)
        
        (logoContainerConstraints +
         [
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 213/64),
            imageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            imageHeightConstraint!,
            titleBottomConstraint!,
            titleLeadingConstraint!,
            titleTrailingConstraint!
        ] + continueButtonConstraints(inView: view)).activate()
    }
    
    private func updateConstraints(for size: CGSize) {
        let height = isPortrait ? LayoutConstants.Vertical.imageHeight : LayoutConstants.Horizontal.imageHeight
        let bottomSpacing = isPortrait ? LayoutConstants.Vertical.titleBottomSpacing : LayoutConstants.Horizontal.titleBottomSpacing
        let padding = isPortrait ? LayoutConstants.Vertical.horizontalPadding : LayoutConstants.Horizontal.horizontalPadding
        
        imageHeightConstraint?.constant = height
        titleBottomConstraint?.constant = bottomSpacing
        titleLeadingConstraint?.constant = padding
        titleTrailingConstraint?.constant = -padding
    }

    private var logoContainerConstraints: [NSLayoutConstraint] {
        [
            logoContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            logoContainerView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            logoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}
