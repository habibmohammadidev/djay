//
//  FeaturesStepViewModel.swift
//  Djay
//

import Foundation
import Combine

class FeaturesStepViewModel {
    let items: [OnboardingFeatureItem] = [
        .image(name: "DjayLogo", aspectRatio: 64/213),
        .image(name: "Hero", aspectRatio: 140/310),
        .text("Mix Your\nFavorite Music"),
        .image(name: "ADA", aspectRatio: 64/203)
    ]
    private let onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    func handleContinue() {
        onComplete()
    }
}

extension FeaturesStepViewModel: AnyFeaturesStepViewModel {
    var buttonTitle: AnyPublisher<String, Never> {
        Just("Continue").eraseToAnyPublisher()
    }
}
