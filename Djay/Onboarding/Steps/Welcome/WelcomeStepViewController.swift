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
    let viewModel: AnyWelcomeStepViewModel
    
    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?
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
        imageView.tag = 999
        
        logoContainerView.addAutoLayoutSubview(imageView)
        
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .textPrimary
        titleLabel.font = .sfProDisplayRegular(size: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.welcomeText
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        logoContainerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        view.addAutoLayoutSubviews(logoContainerView, titleLabel)
        setupConstraints()
    }
}

extension WelcomeStepViewController: OnboardingTransitionable {
    var animatedViews: [UIView] { [ titleLabel] }
    
    func animateExit(completion: @escaping () -> Void) {
        logoContainerView.alpha = 0
        view.layoutIfNeeded()
        UIView.animateSlideOut(views: [titleLabel], completion: completion)
    }
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
        let padding = isPortrait ? LayoutConstants.Vertical.horizontalPadding : LayoutConstants.Horizontal.horizontalPadding
        
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: isPortrait ? 213 : 213)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: isPortrait ? 64 : 64)
        
        titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: padding)
        titleTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -padding)
        
        let aspectRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 213.0/64.0)
        aspectRatioConstraint.priority = .defaultHigh
        
        imageWidthConstraint?.priority = isPortrait ? .required : .defaultLow
        imageHeightConstraint?.priority = isPortrait ? .defaultLow : .required
        
        (logoContainerConstraints +
         [
            aspectRatioConstraint,
            imageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 213),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5),
            imageWidthConstraint!,
            imageHeightConstraint!,
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            titleLeadingConstraint!,
            titleTrailingConstraint!
        ]).activate()
    }
    
    private func updateConstraints(for size: CGSize) {
        let padding = isPortrait ? LayoutConstants.Vertical.horizontalPadding : LayoutConstants.Horizontal.horizontalPadding
        
        imageWidthConstraint?.priority = isPortrait ? .required : .defaultLow
        imageHeightConstraint?.priority = isPortrait ? .defaultLow : .required
        
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
