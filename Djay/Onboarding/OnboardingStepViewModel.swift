//
//  OnboardingStepViewModel.swift
//  Djay
//

import Combine

protocol AnyOnboardingStepViewModel {
    var buttonTitle: AnyPublisher<String, Never> { get }
    var isButtonEnabled: AnyPublisher<Bool, Never> { get }
    func handleContinue()
}
extension AnyOnboardingStepViewModel {
    var isButtonEnabled: AnyPublisher<Bool, Never> {
        Just(true).eraseToAnyPublisher()
    }
}
