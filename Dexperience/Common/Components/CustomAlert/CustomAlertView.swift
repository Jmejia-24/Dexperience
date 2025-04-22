//
//  CustomAlertView.swift
//  Dexperience
//
//  Created by Byron on 4/21/25.
//

import UIKit

final class CustomAlertView: UIView {

    // MARK: - UI Elements

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ])

        return imageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var primaryButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 160)
        ])

        button.addAction(UIAction { [weak self] _ in
            self?.onPrimaryTap?()
        }, for: .touchUpInside)

        return button
    }()

    private lazy var secondaryButton: UIButton = {
        let button = UIButton(type: .system)

        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addAction(UIAction { [weak self] _ in
            self?.onSecondaryTap?()
        }, for: .touchUpInside)

        return button
    }()

    // MARK: - Actions

    var onPrimaryTap: (() -> Void)?
    var onSecondaryTap: (() -> Void)?

    // MARK: - Init

    init(type: CustomAlertType, message: String, primaryTitle: String, secondaryTitle: String? = nil) {
        super.init(frame: .zero)
        setupUI()

        configure(
            type: type,
            message: message,
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle
        )
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configure(type: CustomAlertType, message: String, primaryTitle: String, secondaryTitle: String?) {
        iconImageView.image = type.icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = type.tintColor

        messageLabel.text = message

        primaryButton.setTitle(primaryTitle, for: .normal)
        primaryButton.backgroundColor = type.tintColor

        secondaryButton.setTitle(secondaryTitle, for: .normal)
        secondaryButton.setTitleColor(type.tintColor, for: .normal)

        let stack = UIStackView(arrangedSubviews: [iconImageView, messageLabel, primaryButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center

        if let title = secondaryTitle, !title.isEmpty {
            stack.addArrangedSubview(secondaryButton)
        }

        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}
