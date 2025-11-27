//
//  WelcomeStepViewModel.swift
//  Djay
//

import Foundation
import Combine

class WelcomeStepViewModel {
    let welcomeText = "Welcome to djay!"
    private let onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    func handleContinue() {
        onComplete()
    }
}

extension WelcomeStepViewModel: AnyWelcomeStepViewModel {
    var buttonTitle: AnyPublisher<String, Never> {
        Just("Continue").eraseToAnyPublisher()
    }
}
