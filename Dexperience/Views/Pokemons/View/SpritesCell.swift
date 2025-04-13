//
//  SpritesCell.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

final class SpritesCell: UICollectionViewCell {

    private lazy var normalImageView = makeImageView()
    private lazy var shinyImageView = makeImageView()

    private lazy var normalLabel = makeLabel(text: "Normal")
    private lazy var shinyLabel = makeLabel(text: "Shiny")

    private lazy var normalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [normalLabel, normalImageView])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8

        return stack
    }()

    private lazy var shinyStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [shinyLabel, shinyImageView])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8

        return stack
    }()

    private lazy var spriteStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [normalStack, shinyStack])

        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fillEqually
        stack.spacing = 32
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

    func configure(sprites: Sprites) {
        normalImageView.loadImage(from: URL(string: sprites.other?.officialArtwork?.frontDefault ?? ""))
        shinyImageView.loadImage(from: URL(string: sprites.other?.officialArtwork?.frontShiny ?? ""))
    }
}

private extension SpritesCell {

    func setupViews() {
        contentView.addSubview(spriteStack)

        NSLayoutConstraint.activate([
            spriteStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            spriteStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            spriteStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            spriteStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            normalImageView.heightAnchor.constraint(equalTo: normalImageView.widthAnchor),
            shinyImageView.heightAnchor.constraint(equalTo: shinyImageView.widthAnchor)
        ])
    }

    func makeImageView() -> AsyncCachedImageView {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }

    func makeLabel(text: String) -> UILabel {
        let label = UILabel()

        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .tintColor

        return label
    }
}
