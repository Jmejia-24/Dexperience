//
//  PokemonCell.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class PokemonCellView: UICollectionViewCell {

    private let pokemonImageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label

        return label
    }()

    private let idLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel

        return label
    }()

    private let typesStackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        stack.isHidden = true

        return stack
    }()

    private lazy var nameIDStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, idLabel])

        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 4

        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pokemonImageView, nameIDStackView, typesStackView])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: PokemonCellViewModel) {
        updateUI(with: viewModel)

        viewModel.onUpdate = { [weak self] in
            guard let self else { return }

            DispatchQueue.main.async {
                self.updateUI(with: viewModel)
            }
        }

        typesStackView.isHidden = !viewModel.typeImages.isEmpty
    }
}

private extension PokemonCellView {

    // MARK: - Setup

    func setupViews() {
        contentView.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = pokemonImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            heightConstraint
        ])

        contentView.backgroundColor = .systemBackground
    }

    func updateUI(with viewModel: PokemonCellViewModel) {
        nameLabel.text = viewModel.name
        idLabel.text = viewModel.idText
        pokemonImageView.loadImage(from: viewModel.imageUrl)

        updateTypesStack(with: viewModel.typeImages)
    }

    func updateTypesStack(with images: [UIImage]) {
        typesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        images.forEach { image in
            let imageView = UIImageView(image: image)

            imageView.contentMode = .scaleAspectFit

            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
            heightConstraint.priority = UILayoutPriority(999)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 40),
                heightConstraint
            ])

            typesStackView.addArrangedSubview(imageView)
        }
    }
}
