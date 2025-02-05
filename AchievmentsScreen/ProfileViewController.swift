import UIKit

class ProfileViewController: UIViewController {
    
//    private var cardBottomConstra
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = UIConstants.cardCornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = UIConstants.cardShadowOpacity
        view.layer.shadowOffset = UIConstants.cardShadowOffset
        view.layer.shadowRadius = UIConstants.cardShadowRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = UserInfo.name
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = UserInfo.bio
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.alpha = UIConstants.collectionHiddenAlpha
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupUI()
    }
    
    private func setupUI() {
        let profileStackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, bioLabel])
        profileStackView.axis = .vertical
        profileStackView.spacing = UIConstants.profileStackSpacing
        profileStackView.alignment = .center
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(profileStackView)
        view.addSubview(cardView)
        
        let nameLabelHeight = nameLabel.intrinsicContentSize.height
        let stackViewBottomPadding: CGFloat = 16
        let initialCardPosition = -(CGFloat(nameLabelHeight) + stackViewBottomPadding + view.safeAreaInsets.bottom)
        
        NSLayoutConstraint.activate([
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: initialCardPosition),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingInset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leadingInset),
            cardView.heightAnchor.constraint(equalToConstant: UIConstants.cardViewHeight),
            
            profileStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.profileStackPadding),
            profileStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.profileStackPadding),
            profileStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: UIConstants.avatarImageSize)
            ])
    }


}

