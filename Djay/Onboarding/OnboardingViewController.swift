//
//  OnboardingViewController.swift
//  Djay
//

import UIKit
import Combine

typealias AnyOnboardingStepView = OnboardingTransitionable & UIViewController

class OnboardingViewController: UIViewController {
    private let gradientBackground = GradientView()
    private let containerView = UIView()
    private let pageIndicator = PageIndicatorView()
    private let continueButton = OnboardingButton()
    private var currentViewController: AnyOnboardingStepView?
    private var cancellables = Set<AnyCancellable>()
    
    let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePageIndicator()
        viewModel.start()
    }
    
    private func setupUI () {
        view.addAutoLayoutSubview(gradientBackground)
        view.addAutoLayoutSubview(containerView)
        view.addAutoLayoutSubview(pageIndicator)
        view.addAutoLayoutSubview(continueButton)
        
        containerView.backgroundColor = .clear
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
    
        (
            pageIndicatorConstraints +
            gradientBackgroundConstraints +
            containerViewConstraints +
            continueButtonConstraints
        ).activate()
    }
    
    @objc private func handleContinue() {
        viewModel.currentStepViewModel?.handleContinue()
    }

    private func bindViewModel() {
        viewModel.navigateToViewController
            .compactMap { $0 }
            .sink { [weak self] viewController in
                self?.navigateToViewController(viewController)
                self?.bindButtonTitle()
            }
            .store(in: &cancellables)
        
        viewModel.updatePageIndicator
            .sink { [weak self] currentPage, totalPages in
                self?.pageIndicator.currentPage = currentPage
                self?.pageIndicator.numberOfPages = totalPages
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonTitle() {
        viewModel.currentStepViewModel?.buttonTitle
            .sink { [weak self] title in
                self?.continueButton.setTitle(title)
            }
            .store(in: &cancellables)
        
        viewModel.currentStepViewModel?.isButtonEnabled
            .sink { [weak self] isEnabled in
                self?.continueButton.isEnabled = isEnabled
                self?.continueButton.animateEnabled()
            }
            .store(in: &cancellables)
    }
    
}

extension OnboardingViewController {
    
    private func animatePageIndicator() {
        pageIndicator.alpha = 0
        pageIndicator.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.6, delay: 0.35, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.pageIndicator.alpha = 1
            self.pageIndicator.transform = .identity
        }
    }
    
    private func navigateToViewController(_ viewController: AnyOnboardingStepView) {
        let oldVC = currentViewController
        currentViewController = viewController
        
        addChild(viewController)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let oldVC = oldVC {
            transition(from: oldVC, to: viewController)
        } else {
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            viewController.animateEnter(oldView: nil) {}
        }
    }
    
    private func transition(from oldVC: AnyOnboardingStepView, to newVC: AnyOnboardingStepView) {
        oldVC.willMove(toParent: nil)
        newVC.prepareForEnter(in: containerView)
        containerView.addSubview(newVC.view)
        newVC.view.layoutIfNeeded()
        
        oldVC.animateExit {
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParent()
        }
        
        newVC.animateEnter(oldView: oldVC.view) {
            newVC.didMove(toParent: self)
        }
    }
}

extension OnboardingViewController {
    private var pageIndicatorConstraints: [NSLayoutConstraint] {
        [
            pageIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageIndicator.heightAnchor.constraint(equalToConstant: 20)
        ]
    }
    
    private var gradientBackgroundConstraints: [NSLayoutConstraint] {
        [
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }

    private var containerViewConstraints: [NSLayoutConstraint] {
        [
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16)
        ]
    }
    
    private var continueButtonConstraints: [NSLayoutConstraint] {
        [
            continueButton.bottomAnchor.constraint(equalTo: pageIndicator.topAnchor, constant: -12),
            continueButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 44)
        ]
    }
}
