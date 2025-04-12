//
//  MoveDetailHeaderView.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

import UIKit

final class MoveDetailHeaderView: UIView {

    private let typeImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "PlaceholderImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var tagImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 40, weight: .light)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, tagImageView])

        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    var totalheight: CGFloat {
        typeImageView.frame.height + mainStackView.frame.height
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }

    func setAlpha(_ value: CGFloat) {
        typeImageView.alpha = value
        mainStackView.alpha = value
    }

    func configure(_ move: Move) {
        if let moveType = PokemonType(rawValue: move.type?.name ?? "") {
            typeImageView.image = moveType.image
            tagImageView.image = moveType.tagImage
        }

        nameLabel.text = move.name?.formatted
    }
}

private extension MoveDetailHeaderView {

    func layout() {
        addSubview(typeImageView)
        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            typeImageView.heightAnchor.constraint(equalToConstant: 100),
            typeImageView.widthAnchor.constraint(equalToConstant: 100),
            typeImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            typeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            tagImageView.widthAnchor.constraint(equalToConstant: 120),
            tagImageView.heightAnchor.constraint(equalToConstant: 40),

            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: typeImageView.bottomAnchor, multiplier: 2),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 1)
        ])
    }
}
