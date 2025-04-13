//
//  EvolutionCell.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

import UIKit

final class EvolutionCell: UICollectionViewCell {

    private let fromImageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let toImageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var fromLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    private lazy var toLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    private lazy var minLevelLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tintColor
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let image = UIImageView(image: .arrowIndicator)

        image.contentMode = .scaleAspectFill
        image.tintColor = .secondaryLabel

        return image
    }()

    private lazy var middleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [minLevelLabel, arrowImageView])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        return stack
    }()

    private lazy var fromStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fromImageView, fromLabel])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private lazy var toStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [toImageView, toLabel])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fromStack, middleStack, toStack])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
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

    func configure(with evolution: Evolution) {
        fromLabel.text = evolution.from
        toLabel.text = evolution.to

        if evolution.isVariant {
            minLevelLabel.text = "Variant"
        } else {
            minLevelLabel.text = evolution.minLevel != nil ? "Lv.\(evolution.minLevel ?? 0)" : "Lv. -"
        }

        if let fromURL = URL(string: evolution.fromSprite ?? "") {
            fromImageView.loadImage(from: fromURL)
        }

        if let toURL = URL(string: evolution.toSprite ?? "") {
            toImageView.loadImage(from: toURL)
        }
    }
}

private extension EvolutionCell {

    func setupViews() {
        contentView.addSubview(mainStack)

        let fromImageHeightConstraint = fromImageView.heightAnchor.constraint(equalToConstant: 65)
        fromImageHeightConstraint.priority = .defaultHigh

        let toImageHeightConstraint = toImageView.heightAnchor.constraint(equalToConstant: 65)
        toImageHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            fromStack.widthAnchor.constraint(equalToConstant: 65),
            fromImageHeightConstraint,
            toStack.widthAnchor.constraint(equalToConstant: 65),
            toImageHeightConstraint,
        ])
    }
}
