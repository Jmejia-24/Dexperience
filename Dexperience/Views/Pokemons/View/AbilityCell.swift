//
//  AbilityCell.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

final class AbilityCell: UICollectionViewCell {

    private lazy var indicatorImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "eye.slash"))

        image.contentMode = .scaleAspectFill
        image.tintColor = .tintColor

        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .tintColor
        label.numberOfLines = 0

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        return label
    }()

    private lazy var nameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, indicatorImageView])

        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fill

        return stack
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameStackView, descriptionLabel])

        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fill

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: AbilityCellViewModel) {
        indicatorImageView.isHidden = !viewModel.isHidden
        nameLabel.text = viewModel.name.formatted

        descriptionLabel.text = "Loading..."

        Task {
            try? await viewModel.loadAbilityDescription()

            await MainActor.run {
                descriptionLabel.text = viewModel.shortEffect

                (superview as? UICollectionView)?.performBatchUpdates(nil)
            }
        }
    }
}

private extension AbilityCell {

    func setupViews() {
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            indicatorImageView.heightAnchor.constraint(equalToConstant: 15),
            indicatorImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
}
