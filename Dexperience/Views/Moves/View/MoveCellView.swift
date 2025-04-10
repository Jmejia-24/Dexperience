//
//  MoveCellView.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import UIKit

final class MoveCellView: UICollectionViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: MoveCellViewModel) {
        updateUI(with: viewModel)

        viewModel.onUpdate = { [weak self] in
            guard let self else { return }

            DispatchQueue.main.async {
                self.updateUI(with: viewModel)
            }
        }
    }
}

private extension MoveCellView {

    // MARK: - Setup

    func setupView() {
        contentView.backgroundColor = .secondarySystemBackground

        contentView.addSubview(nameLabel)
        contentView.addSubview(typeImageView)

        let heightConstraint = typeImageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(equalToConstant: 40),
            heightConstraint,
            typeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)

        ])
    }

    func updateUI(with viewModel: MoveCellViewModel) {
        nameLabel.text = viewModel.move?.formattedName

        if let typeImage = viewModel.type?.image {
            typeImageView.image = typeImage
        } else {
            typeImageView.image = #imageLiteral(resourceName: "PlaceholderImage")
        }
    }
}
