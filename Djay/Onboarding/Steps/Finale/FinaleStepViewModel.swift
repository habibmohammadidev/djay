//
//  FinaleStepViewModel.swift
//  Djay
//

import Foundation
import Combine

class FinaleStepViewModel {
    private let onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    func handleContinue() {
        onComplete()
    }
}

extension FinaleStepViewModel: AnyOnboardingStepViewModel {
    var buttonTitle: AnyPublisher<String, Never> {
        Just("Get Started").eraseToAnyPublisher()
    }
}
