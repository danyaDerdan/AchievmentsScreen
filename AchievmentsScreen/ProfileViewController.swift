import UIKit

class ProfileViewController: UIViewController{
    
    
    private var cardBottomConstraint: NSLayoutConstraint!
    private var collectionViewTopConstraint: NSLayoutConstraint!
    private var isCardCollapsed: Bool = true
    private var isDetailCardExpanded: Bool = false
    
    private let achievments = Achievement.demoData
    
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
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIConstants.collectionItemSize
        layout.minimumInteritemSpacing = UIConstants.collectionMinimumInteritemSpacing
        layout.minimumLineSpacing = UIConstants.collectionMinimumLineSpacing
        layout.sectionInset = UIConstants.collectionSectionInset
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
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
        label.alpha = 0
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
        view.backgroundColor = .systemCyan
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        let profileStackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, bioLabel])
        profileStackView.axis = .vertical
        profileStackView.spacing = UIConstants.profileStackSpacing
        profileStackView.alignment = .center
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(profileStackView)
        view.addSubview(cardView)
        view.addSubview(collectionView)
        
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCardTap)))
        
        let nameLabelHeight = nameLabel.intrinsicContentSize.height
        let stackViewBottomPadding: CGFloat = 16
        let initialCardPosition = -(CGFloat(nameLabelHeight) + stackViewBottomPadding + view.safeAreaInsets.bottom)
        cardBottomConstraint = cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: initialCardPosition)
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.cardViewHeight + UIConstants.leadingInset)
        
        NSLayoutConstraint.activate([
            cardBottomConstraint,
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingInset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leadingInset),
            cardView.heightAnchor.constraint(equalToConstant: UIConstants.cardViewHeight),
            
            profileStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.profileStackPadding),
            profileStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.profileStackPadding),
            profileStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            
            collectionViewTopConstraint,
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        cardView.layer.zPosition = 1
    }
    
    private func setupCollectionView() {
        collectionView.register(AchievmentCell.self, forCellWithReuseIdentifier: "AchievementCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = UIConstants.collectionHiddenAlpha
    }
    
    @objc func handleCardTap() {
        isCardCollapsed.toggle()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            if self.isCardCollapsed {
                let nameLabelHeight = self.nameLabel.intrinsicContentSize.height
                let stackViewBottomPadding: CGFloat = 16
                let targetPosition = -(CGFloat(nameLabelHeight) + stackViewBottomPadding + self.view.safeAreaInsets.bottom)
                self.cardBottomConstraint.constant = targetPosition
            } else {
                self.cardBottomConstraint.constant = -(self.view.frame.height - self.view.safeAreaInsets.top - UIConstants.cardViewHeight)
            }
            self.collectionView.transform = self.isCardCollapsed ?
            CGAffineTransform(translationX: 0, y: self.view.frame.height / 2) :
            .identity
            self.collectionView.alpha = self.isCardCollapsed ? 0 : 1
            self.bioLabel.alpha = self.isCardCollapsed ? 0 : 1
            self.view.layoutIfNeeded()
        }) { _ in
            self.collectionView.isUserInteractionEnabled = !self.isCardCollapsed}
            
        
    }
    
    private func showAlert(achievment: Achievement) {
        let alertController = UIAlertController(title: "\(achievment.title)", message: "\(achievment.description)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
    @objc private func openCard(_ sender: UIPinchGestureRecognizer ) {
        if (!isDetailCardExpanded) {
            showDetailView(achievment: achievments[sender.view?.tag ?? 0])
            isDetailCardExpanded = true
        }
    }
    
    @objc private func closeCard(_ sender: UIPinchGestureRecognizer ) {
        if (isDetailCardExpanded) {
            sender.view?.removeFromSuperview()
            isDetailCardExpanded = false
        }
    }
    
    private func showDetailView(achievment: Achievement) {
        let view = UIView()
        view.layer.cornerRadius = UIConstants.cardCornerRadius
        view.backgroundColor = .white
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(closeCard)))
        
        let titleLabel = createLabel(text: achievment.title, font: .boldSystemFont(ofSize: 24))
        let descriptionLabel = createLabel(text: achievment.description, font: .systemFont(ofSize: 18))
        let dateLabel = createLabel(text: achievment.dateOfCompletion, font: .systemFont(ofSize: 14))
        dateLabel.textColor = achievment.color
        let imageView = UIImageView(image: UIImage(systemName: achievment.iconName))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = achievment.color
        let slider = UISlider()
        slider.isEnabled = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.setThumbImage(nil, for: .normal)
        slider.minimumTrackTintColor = achievment.color
        slider.value = Float(achievment.percentage)
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.profileStackSpacing
        stackView.alignment = .center
        
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: UIConstants.leadingInset),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.leadingInset),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.widthAnchor.constraint(equalTo: cardView.widthAnchor)
        ])
        
        view.addSubview(stackView)
        slider.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: UIConstants.leadingInset),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -UIConstants.leadingInset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            
            ])
        if (achievment.percentage != 100) {
            view.addSubview(slider)
            NSLayoutConstraint.activate([
                slider.heightAnchor.constraint(equalToConstant: UIConstants.sliderHeight),
                slider.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: UIConstants.widthMultiplier),
                slider.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
                slider.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: UIConstants.profileStackPadding)
                ])
        }
    }
    
    private func createLabel(text: String?, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath) as? AchievmentCell else { return UICollectionViewCell()}
        cell.configure(with: achievments[indexPath.item])
        cell.tag = indexPath.item
        cell.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(openCard)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert(achievment: achievments[indexPath.item])
    }
    
    
    
    
}
