//
//  App.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

final class App {

    // MARK: - Properties

    var navigationController: AppNavigationController = .init()
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
        let coordinator = route.coordinatorFor(router: self)

        coordinator.start()

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
