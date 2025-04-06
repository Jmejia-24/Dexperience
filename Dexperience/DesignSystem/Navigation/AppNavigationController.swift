//
//  AppNavigationController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class AppNavigationController: UINavigationController {

    // MARK: - Views

    private var bottomLineView: UIView?
    private var previousNavigationBarSize: CGSize = .zero

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
        insertBottomGradientLine()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentSize = navigationBar.bounds.size

        if currentSize != previousNavigationBarSize && currentSize.height > 0 {
            applyGradientBackground(for: currentSize)
            previousNavigationBarSize = currentSize
        }

        updateBottomLineFrame()
    }
}

// MARK: - Private methods

private extension AppNavigationController {

    func setupBaseAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance

        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .clear
    }
    
    func applyGradientBackground(for size: CGSize) {
        let gradientLayer = GradientProvider.make(style: .primary)
        gradientLayer.frame = CGRect(origin: .zero, size: size)

        let overlayLayer = CALayer()
        overlayLayer.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85).cgColor
        overlayLayer.frame = gradientLayer.bounds

        let image = UIGraphicsImageRenderer(size: size).image { context in
            gradientLayer.render(in: context.cgContext)
            overlayLayer.render(in: context.cgContext)
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = image
        appearance.shadowImage = UIImage()

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }

    func insertBottomGradientLine() {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(lineView)

        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 4)
        ])

        let lineGradient = GradientProvider.make(style: .tabBarLine)
        lineGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 4)
        lineView.layer.insertSublayer(lineGradient, at: 0)

        bottomLineView = lineView
    }

    func updateBottomLineFrame() {
        if let lineView = bottomLineView,
           let gradient = lineView.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = lineView.bounds
        }
    }
}
