//
//  OnboardingViewController.swift
//  Djay
//

import UIKit
import Combine

typealias AnyOnboardingStepView = OnboardingTransitionable & UIViewController

class OnboardingViewController: UIViewController {
    private let gradientBackground = GradientView()
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    private let pageIndicator = PageIndicatorView()
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
        view.addAutoLayoutSubview(pageIndicator)
        setupPageViewController()
    
        (
            pageIndicatorConstraints +
            gradientBackgroundConstraints +
            pageViewConstraints
        ).activate()
    }

    private func bindViewModel() {
        viewModel.navigateToViewController
            .compactMap { $0 }
            .sink { [weak self] viewController in
                self?.navigateToViewController(viewController)
            }
            .store(in: &cancellables)
        
        viewModel.updatePageIndicator
            .sink { [weak self] currentPage, totalPages in
                self?.pageIndicator.currentPage = currentPage
                self?.pageIndicator.numberOfPages = totalPages
            }
            .store(in: &cancellables)
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addAutoLayoutSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.subviews.compactMap { $0 as? UIScrollView }.first?.isScrollEnabled = false
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
        currentViewController = viewController
        pageViewController.setViewControllers([viewController], direction: .forward, animated: false)
        viewController.view.layoutIfNeeded()
        viewController.animateTransition()
    }
}

extension OnboardingViewController {
    private var pageView: UIView { pageViewController.view }
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

    private var pageViewConstraints: [NSLayoutConstraint] {
        [
            pageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: pageIndicator.topAnchor, constant: -8)
        ]
    }
}
