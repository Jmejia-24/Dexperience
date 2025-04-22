//
//  CustomAlertViewController.swift
//  Dexperience
//
//  Created by Byron on 4/21/25.
//

import UIKit

final class CustomAlertViewController: UIViewController {

    // MARK: - Properties

    private let alertType: CustomAlertType
    private let message: String
    private let primaryTitle: String
    private let secondaryTitle: String?
    private let onPrimary: (() -> Void)?
    private let onSecondary: (() -> Void)?

    // MARK: - UI Elements

    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView(
            type: alertType,
            message: message,
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle
        )

        view.onPrimaryTap = { [weak self] in
            self?.dismiss(animated: true, completion: self?.onPrimary)
        }

        view.onSecondaryTap = { [weak self] in
            self?.dismiss(animated: true, completion: self?.onSecondary)
        }

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Init

    init(
        type: CustomAlertType,
        message: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        onPrimary: (() -> Void)? = nil,
        onSecondary: (() -> Void)? = nil
    ) {
        self.alertType = type
        self.message = message
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.onPrimary = onPrimary
        self.onSecondary = onSecondary

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutAlert()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateAlertIn()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Intentionally left empty to prevent dismissing the alert by tapping outside
    }

    // MARK: - Setup Methods

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(alertView)
    }

    private func layoutAlert() {
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func animateAlertIn() {
        alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        alertView.alpha = 0

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) { [weak self] in
            self?.alertView.alpha = 1
            self?.alertView.transform = .identity
        }
    }
}
