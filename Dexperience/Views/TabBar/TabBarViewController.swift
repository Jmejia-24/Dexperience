//
//  TabBarViewController.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

final class TabBarViewController<R: TabBarRouter>: UITabBarController {

    // MARK: - Properties

    private let viewModel: TabBarViewModel<R>
    private var topLineView: UIView?
    private var gradientView: UIView?

    // MARK: - Initializers

    init(viewModel: TabBarViewModel<R>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !viewModel.tabBarGradientApplied else {
            updateTabBarGradientFrames()
            return
        }

        applyTabBarCustomBackground()
        addTabBarTopGradientLine()

        viewModel.tabBarGradientApplied = true
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.didSelect(tag: item.tag)
    }
}

// MARK: - Private methods

private extension TabBarViewController {

    func setupUI() {
        tabBar.tintColor = .black
    }

    func applyTabBarCustomBackground() {
        guard let tabBarSuperview = tabBar.superview else { return }

        let backgroundView = UIView()

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tabBarSuperview.insertSubview(backgroundView, belowSubview: tabBar)

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])

        let gradient = GradientProvider.make(style: .primary)

        backgroundView.layer.insertSublayer(gradient, at: 0)

        let overlay = UIView()

        overlay.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
        overlay.translatesAutoresizingMaskIntoConstraints = false

        tabBar.insertSubview(overlay, at: 0)

        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: tabBar.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])

        gradientView = backgroundView
    }

    func addTabBarTopGradientLine() {
        guard let tabBarSuperview = tabBar.superview else { return }

        let lineView = UIView()

        lineView.translatesAutoresizingMaskIntoConstraints = false
        tabBarSuperview.addSubview(lineView)

        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 4)
        ])

        let gradient = GradientProvider.make(style: .tabBarLine)

        lineView.layer.insertSublayer(gradient, at: 0)

        topLineView = lineView
    }

    func updateTabBarGradientFrames() {
        if let backgroundView = gradientView,
           let gradient = backgroundView.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = backgroundView.bounds
        }

        if let lineView = topLineView,
           let lineGradient = lineView.layer.sublayers?.first as? CAGradientLayer {
            lineGradient.frame = lineView.bounds
        }
    }
}
