//
//  SectionHeaderView.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "CenteredSectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .tintColor
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }
}
