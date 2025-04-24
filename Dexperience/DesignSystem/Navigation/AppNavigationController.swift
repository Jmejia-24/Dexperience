//
//  AppNavigationController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class AppNavigationController: UINavigationController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }
}

// MARK: - Private methods

private extension AppNavigationController {

    func configureAppearance() {
        let appearance = UINavigationBarAppearance()

        appearance.backgroundEffect = .init(style: .prominent)
        appearance.shadowColor = .clear
        appearance.shadowImage = nil

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
