import UIKit
import Combine

enum OnboardingFeatureItem {
    case image(name: String, aspectRatio: CGFloat)
    case text(String)
}

protocol AnyFeaturesStepViewModel: AnyOnboardingStepViewModel {
    var items: [OnboardingFeatureItem] { get }
}

class FeaturesStepViewController: UIViewController {
    typealias Item = OnboardingFeatureItem
    private var collectionView: UICollectionView!
    private var collectionViewWidthConstraint: NSLayoutConstraint?
    private var bag: AnyCancellable?

    let continueButton = OnboardingButton()
    let viewModel: AnyFeaturesStepViewModel
    
    init(viewModel: AnyFeaturesStepViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateCollectionViewWidth()
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        let layout = CenteredCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        view.addAutoLayoutSubviews(collectionView, continueButton)
        bag = viewModel.buttonTitle
            .sink { [weak self] title in self?.continueButton.setTitle(title) }
        setupConstraints()
    }
    
    @objc private func handleContinue() {
        viewModel.handleContinue()
    }
    
    private func setupConstraints() {
        ([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16)
        ] + continueButtonConstraints(inView: view)).activate()
        updateCollectionViewWidth()
    }
    
    private func updateCollectionViewWidth() {
        collectionViewWidthConstraint?.isActive = false
        collectionViewWidthConstraint = collectionView.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor, constant: -40)
        collectionViewWidthConstraint?.isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension FeaturesStepViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.items[indexPath.item] {
        case .image(let name, let aspectRatio):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.configure(imageName: name, aspectRatio: aspectRatio)
            return cell
        case .text(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.configure(text: text)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeaturesStepViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = isLandscape ? 2 : 1
        let spacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width
        let width = (availableWidth - spacing * (columns - 1)) / columns
        
        return switch viewModel.items[indexPath.item] {
        case .image(_, let aspectRatio): CGSize(width: width, height: width * aspectRatio)
        case .text: CGSize(width: width, height: isLandscape ? 100 : 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let columns: CGFloat = isLandscape ? 2 : 1
        let spacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width
        let cellWidth = (availableWidth - spacing * (columns - 1)) / columns
        let totalCellWidth = cellWidth * columns + spacing * (columns - 1)
        let leftInset = (availableWidth - totalCellWidth) / 2
        return UIEdgeInsets(top: 0, left: max(0, leftInset), bottom: 0, right: max(0, leftInset))
    }
}

// MARK: - Transitions
extension FeaturesStepViewController: OnboardingTransitionable {
    var animatedViews: [UIView] { collectionView.visibleCells + [continueButton] }
}

extension FeaturesStepViewController {
    // MARK: - Layout
    class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let attributes = super.layoutAttributesForElements(in: rect),
                  let collectionView = collectionView else { return nil }
            
            let contentHeight = collectionViewContentSize.height
            let collectionViewHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
            
            if contentHeight < collectionViewHeight {
                let topInset = (collectionViewHeight - contentHeight) / 2
                return attributes.map { attr in
                    let newAttr = attr.copy() as! UICollectionViewLayoutAttributes
                    newAttr.frame.origin.y += topInset
                    return newAttr
                }
            }
            
            return attributes
        }
    }

    // MARK: - Cells
    class ImageCell: UICollectionViewCell {
        private let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.contentMode = .center
            contentView.addAutoLayoutSubviews(imageView)
            contentView.edgeConstraints(for: imageView).activate()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(imageName: String, aspectRatio: CGFloat) {
            imageView.image = UIImage(named: imageName)
        }
    }
    
    class TextCell: UICollectionViewCell {
        private let label = UILabel()
        private var labelBottomConstraint: NSLayoutConstraint!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            label.font = .sfProDisplayHeavy(size: 34)
            label.textColor = .textPrimary
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true //TODO: Habib cut off iOS 17
            label.numberOfLines = 2
            contentView.addAutoLayoutSubviews(label)
            labelBottomConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            [
                label.topAnchor.constraint(equalTo: contentView.topAnchor),
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                labelBottomConstraint
            ].activate()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            labelBottomConstraint.constant = isLandscape ? -8 : 0
            label.setNeedsDisplay()
        }
        
        func configure(text: String) {
            label.text = text
        }
    }
}
