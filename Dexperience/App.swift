//
//  App.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

final class App {

    // MARK: - Properties

    var navigationController: UINavigationController = .init()
    var primaryViewController: UIViewController { .init() }
}

// MARK: - Coordinator

extension App: Coordinator {

    func start() {
        process(route: .showTabBar)
    }
}

// MARK: - App Router

extension App: AppRouter {

    func process(route: AppTransition) {
#if DEBUG

        let routeInfo = """
        🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍\n
        🟢🚀 Processing Route 🟢🚀
        🛣️ Route Identifier: \(route.identifier)
        \n🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚\n
        """

        print(routeInfo)

#endif
    }

    func exit() {
        navigationController.popToRootViewController(animated: true)
    }
}
