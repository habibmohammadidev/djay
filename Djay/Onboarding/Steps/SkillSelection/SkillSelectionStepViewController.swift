//
//  SkillSelectionStepViewController.swift
//  Djay
//

import UIKit
import Combine

protocol AnySkillSelectionStepViewModel: AnyOnboardingStepViewModel {
    var title: String { get }
    var subTitle: String { get }
    var skillOptions: [SkillLevel] { get }
    var selectedSkillPublisher: AnyPublisher<SkillLevel?, Never> { get }
    var isButtonEnabled: AnyPublisher<Bool, Never> { get }
    func onSkillLevelSelection(selectedSkill: SkillLevel)
}

class SkillSelectionStepViewController: UIViewController {
    private let iconImageView = UIImageView() //TODO: Habib size in SE landscapge
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let headTitlesStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let skillStackView = UIStackView()
    private let contentStackView = UIStackView()
    private var skillOptionViews: [SkillOptionView] = []
    let viewModel: AnySkillSelectionStepViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AnySkillSelectionStepViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateStackViewLayout()
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        iconImageView.image = UIImage(named: "OnboardinSkillIcon")
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.title
        
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = viewModel.subTitle
        
        headTitlesStackView.axis = .vertical
        headTitlesStackView.spacing = 12
        headTitlesStackView.alignment = .center
        headTitlesStackView.addArrangedSubview(titleLabel)
        headTitlesStackView.addArrangedSubview(subtitleLabel)
        
        headerStackView.axis = .vertical
        headerStackView.spacing = 16
        headerStackView.alignment = .center
        headerStackView.addArrangedSubview(iconImageView)
        headerStackView.addArrangedSubview(headTitlesStackView)
        
        skillStackView.axis = .vertical
        skillStackView.spacing = 12
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.alignment = .center
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(skillStackView)
        
        view.addAutoLayoutSubviews(contentStackView)
        contentStackViewConstraints.activate()
        
        setupSkillOptions()
        updateStackViewLayout()
    }
    
    private func setupSkillOptions() {
        for level in viewModel.skillOptions {
            let optionView = SkillOptionView(title: level.rawValue)
            optionView.onTap = { [weak self] in
                self?.viewModel.onSkillLevelSelection(selectedSkill: level)
            }
            skillStackView.addArrangedSubview(optionView)
            skillOptionViews.append(optionView)
        }
    }
    
    private func bindViewModel() {
        viewModel.selectedSkillPublisher
            .sink(receiveValue: updateSelection(for:))
            .store(in: &cancellables)
    }
    
    private func updateSelection(for skill: SkillLevel?) {
        skillOptionViews.forEach { $0.isSelected = false }
        guard let skill, let index = viewModel.skillOptions.firstIndex(of: skill) else { return }
        skillOptionViews[index].isSelected = true
    }
    
    private func updateStackViewLayout() {
        titleLabel.textAlignment = isLandscape ? .natural : .center
        subtitleLabel.textAlignment = isLandscape ? .natural : .center
        headTitlesStackView.alignment = isLandscape ? .leading : .center
        headerStackView.axis = isLandscape ? .horizontal : .vertical
        skillStackView.axis = isLandscape ? .horizontal : .vertical
        skillStackView.distribution = isLandscape ? .fillEqually : .fill
        skillStackView.spacing = isLandscape ? 16 : 12
        iconImageView.heightAnchor.constraint(equalToConstant: isLandscape ? 40 : 60).isActive = true
    }
}

extension SkillSelectionStepViewController: OnboardingTransitionable {
    var animatedViews: [UIView] { [ iconImageView, titleLabel, subtitleLabel] + skillOptionViews  }
}

extension SkillSelectionStepViewController {
    private var contentStackViewConstraints: [NSLayoutConstraint] {
        [
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            contentStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            skillStackView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ]
    }
}
