//
//  ItemCellView.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import UIKit

final class ItemCellView: UICollectionViewCell {

    private let itemImageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var costLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .right

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var costImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = #imageLiteral(resourceName: "CostIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, costLabel])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8

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

    func configure(with viewModel: ItemCellViewModel) {
        Task { @MainActor in
            let item = try? await viewModel.fetchDetails()

            updateUI(with: item)
        }
    }
}

private extension ItemCellView {

    // MARK: - Setup

    func setupView() {
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(itemImageView)
        contentView.addSubview(costImageView)
        contentView.addSubview(itemImageView)
        contentView.addSubview(textStackView)

        let itemImageHeightConstraint = itemImageView.heightAnchor.constraint(equalToConstant: 40)
        itemImageHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: 40),
            itemImageHeightConstraint,

            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            costImageView.widthAnchor.constraint(equalToConstant: 11),
            costImageView.heightAnchor.constraint(equalToConstant: 15),
            costImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            costImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: costImageView.leadingAnchor, constant: -8),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)

        ])
    }

    func updateUI(with item: Item?) {
        nameLabel.text = item?.name?.formatted
        costLabel.text = "\(item?.cost ?? 0)"

        itemImageView.loadImage(from: URL(string: item?.sprites?.spriteDefault ?? ""))
    }
}
