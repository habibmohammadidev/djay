//
//  OnboardingViewController.swift
//  Djay
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidComplete()
}

class OnboardingViewController: UIViewController {
    private let gradientBackground = GradientView()
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    private let pageIndicator = PageIndicatorView()
    private let continueButton = UIButton(type: .system)
    private var currentViewController: (UIViewController & OnboardingTransitionable)?
    
    let viewModel: OnboardingViewModel
    weak var delegate: OnboardingViewControllerDelegate?
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupPageViewController()
        setupContinueButton()
        setupPageIndicator()
        setupInitialSteps()
    }
    
    private func setupGradientBackground() {
        view.addSubview(gradientBackground)
        gradientBackground.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.didMove(toParent: self)
        pageViewController.delegate = self
    }
    
    private func setupContinueButton() {
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        continueButton.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
        continueButton.layer.cornerRadius = 12
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            continueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupPageIndicator() {
        view.addSubview(pageIndicator)
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageIndicator.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupInitialSteps() {
        pageIndicator.numberOfPages = viewModel.totalSteps
        pageIndicator.currentPage = 0
        
        if let viewController = viewModel.getInitialViewController() {
            currentViewController = welcomeVC
            pageViewController.setViewControllers([welcomeVC], direction: .forward, animated: false)
            updateButtonTitle()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomInset = continueButton.frame.height + 48 + pageIndicator.frame.height + 24
        pageViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height - bottomInset
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateButtonAndIndicator()
    }
    
    private func animateButtonAndIndicator() {
        continueButton.alpha = 0
        pageIndicator.alpha = 0
        continueButton.transform = CGAffineTransform(translationX: 0, y: 20)
        pageIndicator.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.continueButton.alpha = 1
            self.continueButton.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.35, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.pageIndicator.alpha = 1
            self.pageIndicator.transform = .identity
        }
    }
    
    @objc private func handleContinue() {
        let data = (currentViewController as? SkillSelectionStepViewController)?.viewModel.selectedLevel
        viewModel.completeCurrentStep(with: data)
    }
    
    private func updateButtonTitle() {
        guard let currentVC = currentViewController else { return }
        
        let buttonTitle: String
        let isEnabled: Bool
        
        switch currentVC {
        case let vc as WelcomeStepViewController:
            buttonTitle = vc.viewModel.buttonTitle
            isEnabled = true
        case let vc as FeaturesStepViewController:
            buttonTitle = vc.viewModel.buttonTitle
            isEnabled = true
        case let vc as SkillSelectionStepViewController:
            buttonTitle = vc.viewModel.buttonTitle
            isEnabled = vc.viewModel.isContinueEnabled
        case let vc as FinaleStepViewController:
            buttonTitle = vc.viewModel.buttonTitle
            isEnabled = true
        default:
            buttonTitle = "Continue"
            isEnabled = true
        }
        
        continueButton.setTitle(buttonTitle, for: .normal)
        continueButton.isEnabled = isEnabled
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, animationControllerFor direction: UIPageViewController.NavigationDirection) -> UIViewControllerAnimatedTransitioning? {
        OnboardingTransitionAnimator(isForward: direction == .forward)
    }
}

extension OnboardingViewController: SkillSelectionStepViewModelDelegate {
    func didSelectSkillLevel(_ level: SkillLevel) {
        updateButtonTitle()
    }
}

extension OnboardingViewController: OnboardingViewModelDelegate {
    func shouldNavigateToViewController(_ viewController: UIViewController & OnboardingTransitionable) {
        currentViewController = viewController
        pageViewController.setViewControllers([viewController], direction: .forward, animated: true) { [weak self] completed in
            guard completed, let self = self else { return }
            self.updateButtonTitle()
        }
    }
    
    func shouldUpdatePageIndicator(currentPage: Int, totalPages: Int) {
        pageIndicator.currentPage = currentPage
        pageIndicator.numberOfPages = totalPages
    }
    
    func onboardingDidComplete() {
        delegate?.onboardingDidComplete()
    }
}


