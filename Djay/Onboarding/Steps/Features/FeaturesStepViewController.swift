import UIKit
import Combine

enum OnboardingFeatureItem {
    case image(name: String, aspectRatio: CGFloat, tag: Int? = nil)
    case text(String)
}

protocol AnyFeaturesStepViewModel: AnyOnboardingStepViewModel {
    var items: [OnboardingFeatureItem] { get }
}

class FeaturesStepViewController: UIViewController {
    typealias Item = OnboardingFeatureItem
    private var collectionView: UICollectionView!
    private var collectionViewWidthConstraint: NSLayoutConstraint?

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
        
        view.addAutoLayoutSubviews(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ].activate()
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
        case .image(let name, let aspectRatio, let tag):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.configure(imageName: name, aspectRatio: aspectRatio, tag: tag)
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
        let rows: CGFloat = CGFloat(viewModel.items.count) / columns
        let spacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width
        let availableHeight = collectionView.bounds.height
        let width = (availableWidth - spacing * (columns - 1)) / columns
        
        switch viewModel.items[indexPath.item] {
        case .image(_, let aspectRatio, _): 
            let height = width * aspectRatio
            return CGSize(width: width, height: min(height, availableHeight / rows))
        case .text:
            return CGSize(width: width, height: min(isLandscape ? 100 : 80, availableHeight / rows))
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
    var animatedViews: [UIView] { collectionView.visibleCells.map(\.contentView) }
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
        private var ratioConstraint: NSLayoutConstraint! { didSet { oldValue.isActive = false } }
        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.contentMode = .scaleAspectFit
            contentView.addAutoLayoutSubviews(imageView)

            [imageView.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
             imageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
             imageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.widthAnchor),
             imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.heightAnchor)
            ].activate()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(imageName: String, aspectRatio: CGFloat, tag: Int?) {
            imageView.tag = tag ?? 0
            imageView.image = UIImage(named: imageName)
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio).isActive = true
        }
    }
    
    class TextCell: UICollectionViewCell {
        private let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            label.font = .sfProDisplayHeavy(size: 34)
            label.textColor = .textPrimary
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true //TODO: Habib cut off iOS 17
            label.numberOfLines = 2
            contentView.addAutoLayoutSubviews(label)
            contentView.readableContentGuide
                .edgeConstraints(for: label)
                .activate()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            label.setNeedsDisplay()
        }
        
        func configure(text: String) {
            label.text = text
        }
    }
}
