//
//  SkillSelectionStepViewModel.swift
//  Djay
//

import Foundation
import Combine

class SkillSelectionStepViewModel {
    let selectedSkill = CurrentValueSubject<SkillLevel?, Never>(nil)
    private let onComplete: () -> Void
    private(set) var selectedLevel: SkillLevel?
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    func selectSkillLevel(_ level: SkillLevel) {
        selectedLevel = level
    }
    
    func handleContinue() {
        onComplete()
    }
}

extension SkillSelectionStepViewModel: AnySkillSelectionStepViewModel {
    var title: String { "Choose Your Level" }
    var subTitle: String { "Select your DJ experience level" }
    var buttonTitle: AnyPublisher<String, Never> { Just("Continue").eraseToAnyPublisher() }

    var isButtonEnabled: AnyPublisher<Bool, Never> {
        selectedSkill
            .map { $0 != nil }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var selectedSkillPublisher: AnyPublisher<SkillLevel?, Never> {
        self.selectedSkill.eraseToAnyPublisher()
    }

    var skillOptions: [SkillLevel] { SkillLevel.allCases }

    func onSkillLevelSelection(selectedSkill skill: SkillLevel) {
        selectedSkill.send(skill)
    }
}
