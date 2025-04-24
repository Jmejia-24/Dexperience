//
//  LoaderView.swift
//  Dexperience
//
//  Created by Byron on 4/23/25.
//

import UIKit

@MainActor
final class LoaderView: UIView {

    static let shared = LoaderView()

    private(set) var isVisible = false

    private let backgroundView: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let containerView: UIView = {
        let view = UIView()

        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let imageView: UIImageView = {

        let imageView = UIImageView(image: .placeholder)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 100),
            containerView.heightAnchor.constraint(equalToConstant: 100),

            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func show(in parent: UIView? = nil) {
        guard !isVisible,
              let container = parent ?? Self.keyWindow else { return }

        container.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor),
            bottomAnchor.constraint(equalTo: container.bottomAnchor),
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        startRotation()

        isVisible = true
    }

    func hide() {
        guard isVisible else { return }

        stopRotation()
        removeFromSuperview()

        isVisible = false
    }

    func show(for duration: TimeInterval, in parent: UIView? = nil) async {
        show(in: parent)

        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))

        hide()
    }

    func performWhileShowingLoader<T>(in parent: UIView? = nil, _ operation: @escaping () async throws -> T) async throws -> T {
        show(in: parent)

        defer { hide() }

        return try await operation()
    }

    func performWhileShowingLoader(in parent: UIView? = nil, _ operation: @escaping () async -> Void) async {
        show(in: parent)

        defer { hide() }

        await operation()
    }
}

private extension LoaderView {

    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    func startRotation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")

        rotation.toValue = Double.pi * 2
        rotation.duration = 1.2
        rotation.repeatCount = .infinity

        imageView.layer.add(rotation, forKey: "rotation")
    }


    func stopRotation() {
        imageView.layer.removeAnimation(forKey: "rotation")
    }
}

