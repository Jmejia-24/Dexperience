//
//  TripleColumnBaseCell.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

class TripleColumnBaseCell: UICollectionViewCell {

    private let columnStack = UIStackView()
    private let separator1 = UIView()
    private let separator2 = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBaseLayout() {
        columnStack.axis = .horizontal
        columnStack.distribution = .fillEqually
        columnStack.alignment = .fill
        columnStack.spacing = 0
        columnStack.translatesAutoresizingMaskIntoConstraints = false

        [separator1, separator2].forEach {
            $0.backgroundColor = .systemGray4
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentView.addSubview(columnStack)
        contentView.addSubview(separator1)
        contentView.addSubview(separator2)

        NSLayoutConstraint.activate([
            columnStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            columnStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            columnStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            columnStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func configureColumns(_ columns: [UIView]) {
        columnStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        [separator1, separator2].forEach { $0.removeFromSuperview() }

        for (index, view) in columns.enumerated() {
            columnStack.addArrangedSubview(view)

            if index < columns.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .systemGray4
                separator.translatesAutoresizingMaskIntoConstraints = false

                contentView.addSubview(separator)

                NSLayoutConstraint.activate([
                    separator.centerXAnchor.constraint(equalTo: view.trailingAnchor),
                    separator.topAnchor.constraint(equalTo: columnStack.topAnchor),
                    separator.bottomAnchor.constraint(equalTo: columnStack.bottomAnchor),
                    separator.widthAnchor.constraint(equalToConstant: 1)
                ])
            }
        }
    }
}
