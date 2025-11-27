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

extension FinaleStepViewModel: AnyFinaleStepViewModel {
    var title: String { "You're All Set!" }
    var subtitle: String { "Let's start your journey" }
    var buttonTitle: AnyPublisher<String, Never> {
        Just("Get Started").eraseToAnyPublisher()
    }
}
