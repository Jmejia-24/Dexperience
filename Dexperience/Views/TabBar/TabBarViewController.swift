//
//  TabBarViewController.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

final class TabBarViewController<R: TabBarRouter>: UITabBarController {

    // MARK: - Properties

    let viewModel: TabBarViewModel<R>

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
        configureAppearance()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.didSelect(tag: item.tag)
    }
}

// MARK: - Private methods

private extension TabBarViewController {

    func configureAppearance() {
        let appearance = UITabBarAppearance()

        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = .init(style: .prominent)
        appearance.shadowColor = .clear
        appearance.shadowImage = nil

        appearance.applyItemColors(
            normalTitleColor: .secondaryLabel,
            normalIconColor: .secondaryLabel,
            selectedTitleColor: .label,
            selectedIconColor: .label
        )

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
