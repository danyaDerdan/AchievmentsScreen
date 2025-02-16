import UIKit

final class ProfileViewController: UIViewController {
    
    
    private var cardBottomConstraint: NSLayoutConstraint?
    private var collectionViewTopConstraint: NSLayoutConstraint?
    private var isCardCollapsed: Bool = true
    private var isDetailCardExpanded: Bool = false
    private let detailView: DetailView? = DetailView()
    
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
        guard let cardBottomConstraint else { return }
        guard let collectionViewTopConstraint else { return }
        
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
        setupDetailView()
    }
    
    private func setupCollectionView() {
        collectionView.register(AchievmentCell.self, forCellWithReuseIdentifier: "AchievementCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = UIConstants.collectionHiddenAlpha
    }
    
    @objc func handleCardTap() {
        isCardCollapsed.toggle()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            guard let cardBottomConstraint else { return }
            if self.isCardCollapsed {
                let nameLabelHeight = self.nameLabel.intrinsicContentSize.height
                let stackViewBottomPadding: CGFloat = 16
                let targetPosition = -(CGFloat(nameLabelHeight) + stackViewBottomPadding + self.view.safeAreaInsets.bottom)
                self.cardBottomConstraint?.constant = targetPosition
            } else {
                self.cardBottomConstraint?.constant = -(self.view.frame.height - self.view.safeAreaInsets.top - UIConstants.cardViewHeight)
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
            detailView?.configure(with: achievments[sender.view?.tag ?? 0])
            detailView?.isHidden = false
            isDetailCardExpanded = true
        }
    }
    
    @objc private func closeCard(_ sender: UIPinchGestureRecognizer ) {
        if (isDetailCardExpanded) {
            sender.view?.isHidden = true
            isDetailCardExpanded = false
        }
    }
    
    private func setupDetailView() {
        guard let detailView else { return }
        detailView.isHidden = true
        view.addSubview(detailView)
        detailView.layer.cornerRadius = UIConstants.cardCornerRadius
        detailView.backgroundColor = .white
        detailView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(closeCard)))
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: UIConstants.leadingInset),
            detailView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.leadingInset),
            detailView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            detailView.widthAnchor.constraint(equalTo: cardView.widthAnchor)
        ])
        detailView.setup()
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
