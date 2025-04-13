//
//  StatBarCell.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

import UIKit

final class StatBarCell: UICollectionViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .tintColor

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.setContentHuggingPriority(.required, for: .horizontal)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)

        progress.trackTintColor = .systemGray5
        progress.progressTintColor = .tintColor
        progress.layer.cornerRadius = 4
        progress.clipsToBounds = true

        return progress
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, valueLabel, progressView])

        stack.axis = .horizontal
        stack.alignment = .center

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with stat: StatDisplay) {
        nameLabel.text = stat.shortName
        valueLabel.text = "\(stat.value)"
        progressView.progress = normalizedStatValue(stat.value)
    }
}

private extension StatBarCell {

    func setupUI() {
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ])

        [nameLabel, valueLabel].forEach { label in
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 40)
            ])
        }
    }

    func normalizedStatValue(_ stat: Int, maxStat: Int = 260) -> Float {
        let clamped = min(stat, maxStat)

        let value = CGFloat(clamped) / CGFloat(maxStat)

        return Float(value)
    }
}
