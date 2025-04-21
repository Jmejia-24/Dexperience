//
//  PokemonCardView.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import UIKit

final class PokemonCardView: UIView {

    private let pokemonImageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label

        return label
    }()

    private lazy var idLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel

        return label
    }()

    private lazy var typesStackView: UIStackView = {
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

    func prepareForReuse() {
        typesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        nameLabel.text = nil
        idLabel.text = nil
    }

    func configure(with pokemon: Pokemon?) {
        nameLabel.text = pokemon?.name?.capitalized
        idLabel.text = "#\(pokemon?.id ?? 0)"

        pokemonImageView.loadImage(from: URL(string: pokemon?.sprites?.other?.officialArtwork?.frontDefault ?? ""))

        typesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let types = pokemon?.types {
            let images: [UIImage] = types.compactMap { typeInfo in
                guard let name = typeInfo.type?.name else { return nil }

                return PokemonType(rawValue: name)?.image
            }

            updateTypesStack(with: images)

            typesStackView.isHidden = images.isEmpty
        } else {
            typesStackView.isHidden = true
        }
    }
}

private extension PokemonCardView {

    func setupViews() {
        addSubview(mainStackView)

        let heightConstraint = pokemonImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            heightConstraint
        ])
    }

    func updateTypesStack(with images: [UIImage]) {
        typesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        images.forEach { image in
            let imageView = UIImageView(image: image)

            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false

            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
            heightConstraint.priority = .defaultHigh

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 40),
                heightConstraint
            ])

            typesStackView.addArrangedSubview(imageView)
        }
    }
}
