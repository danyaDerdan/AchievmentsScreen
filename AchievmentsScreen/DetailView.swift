import UIKit

final class DetailView: UIView {
    private var achievment: Achievement?
    private var titleLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var dateLabel: UILabel?
    private let imageView: UIImageView? = UIImageView()
    private let slider: UISlider? = UISlider()
    
    public func setup() {
        
        titleLabel = createLabel(text: "", font: .boldSystemFont(ofSize: 24))
        descriptionLabel = createLabel(text: "", font: .systemFont(ofSize: 18))
        dateLabel = createLabel(text: "", font: .systemFont(ofSize: 14))
        guard let imageView else { return }
        guard let slider else { return }
        
        imageView.contentMode = .scaleAspectFill
        slider.isEnabled = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel ?? UILabel(), descriptionLabel ?? UILabel(), dateLabel ?? UILabel()])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.profileStackSpacing
        stackView.alignment = .center
        
        addSubview(stackView)
        slider.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UIConstants.leadingInset),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIConstants.leadingInset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            ])
        
        addSubview(slider)
        NSLayoutConstraint.activate([
            slider.heightAnchor.constraint(equalToConstant: UIConstants.sliderHeight),
            slider.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: UIConstants.widthMultiplier),
            slider.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            slider.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: UIConstants.profileStackPadding)
            ])
    }
    
    public func configure(with achievement: Achievement?) {
        self.achievment = achievement
        titleLabel?.text = achievement?.title
        descriptionLabel?.text = achievement?.description
        dateLabel?.text = achievement?.dateOfCompletion
        dateLabel?.textColor = achievement?.color
        imageView?.tintColor = achievement?.color
        imageView?.image = UIImage(systemName: achievement?.iconName ?? "checkmark")
        slider?.value = Float(achievement?.percentage ?? 0)
        slider?.minimumTrackTintColor = achievement?.color
        slider?.isHidden = achievement?.percentage == 100 ? true : false
        
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
