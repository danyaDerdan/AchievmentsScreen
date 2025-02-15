import UIKit

private enum UICellConstants {
    static let cornerRadius: CGFloat = 16
    static let shadowOpacity: Float = 0.1
    static let shadowRadius: CGFloat = 4
    static let shadowOffset: CGSize = CGSize(width: 0, height: 2)
    static let imageHeight: CGFloat = 60
    static let stackSpacing: CGFloat = 8
    static let stackPadding: CGFloat = 8
    static let titleLabelFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
    static let titleLabelTextColor: UIColor = .black
}

final class AchievmentCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UICellConstants.titleLabelFont
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = UICellConstants.titleLabelTextColor
        return label
    }()
    
    private func setupUI() {
        layer.cornerRadius = UICellConstants.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = UICellConstants.shadowOpacity
        layer.shadowRadius = UICellConstants.shadowRadius
        layer.shadowOffset = UICellConstants.shadowOffset
        
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = UICellConstants.stackSpacing
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UICellConstants.imageHeight)
            ])
    }
    
    func configure(with achievment: Achievement) {
        setupUI()
        backgroundColor = achievment.percentage == 100 ? .white : .systemGray6
        nameLabel.text = achievment.title
        imageView.image = UIImage(systemName: achievment.iconName)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = achievment.color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageView.image = nil
        imageView.tintColor = nil
    }
}

        
