//
//  ItemDetailHeaderView.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

import UIKit

final class ItemDetailHeaderView: UIView {

    private let imageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "PlaceholderImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var costImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = #imageLiteral(resourceName: "CostIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel

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

    private lazy var costLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .right

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var costStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [costLabel, costImageView])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5

        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, costStackView])

        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    var totalheight: CGFloat {
        imageView.frame.height + mainStackView.frame.height
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
        imageView.alpha = value
        mainStackView.alpha = value
    }

    func configure(_ item: Item) {
        if let imageUrl = URL(string: item.sprites?.spriteDefault ?? "") {
            imageView.loadImage(from: imageUrl)
        }

        nameLabel.text = item.name?.formatted
        costLabel.text = "\(item.cost ?? 0)"
    }
}

private extension ItemDetailHeaderView {

    func layout() {
        addSubview(imageView)
        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            costImageView.widthAnchor.constraint(equalToConstant: 11),
            costImageView.heightAnchor.constraint(equalToConstant: 15),

            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 2),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 1)
        ])
    }
}
