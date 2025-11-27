//
//  OnboardingTransitionable.swift
//  Djay
//

import UIKit

protocol OnboardingTransitionable: UIViewController {
    func animateTransition(using context: UIViewControllerContextTransitioning, direction: UIPageViewController.NavigationDirection, transitionCoordinator: UIViewControllerTransitionCoordinator?)
}
