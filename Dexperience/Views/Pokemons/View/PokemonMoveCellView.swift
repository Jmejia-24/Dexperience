//
//  PokemonMoveCellView.swift
//  Dexperience
//
//  Created by Byron on 4/14/25.
//

import UIKit

final class PokemonMoveCellView: UICollectionViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var levelLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .secondaryLabel

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, levelLabel])

        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: PokemonMoveCellViewModel) {
        updateUI(with: viewModel)

        viewModel.onUpdate = { [weak self] in
            guard let self else { return }

            DispatchQueue.main.async {
                self.updateUI(with: viewModel)
            }
        }
    }
}

private extension PokemonMoveCellView {

    // MARK: - Setup

    func setupView() {
        contentView.addSubview(textStackView)
        contentView.addSubview(typeImageView)

        let heightConstraint = typeImageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(equalToConstant: 40),
            heightConstraint,
            typeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textStackView.trailingAnchor.constraint(equalTo: typeImageView.leadingAnchor, constant: -8),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    func updateUI(with viewModel: PokemonMoveCellViewModel) {
        nameLabel.text = viewModel.pokemonMove.move?.name?.formatted
        levelLabel.text = "Level: \(viewModel.pokemonMove.level)"

        if let typeImage = viewModel.type?.image {
            typeImageView.image = typeImage
        } else {
            typeImageView.image = #imageLiteral(resourceName: "PlaceholderImage")
        }
    }
}
