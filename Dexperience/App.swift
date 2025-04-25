//
//  App.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

final class App {

    // MARK: - Properties

    private let parser = DeepLinkParser()
    private lazy var navigator: DeepLinkNavigator<App> = .init(router: self)

    var navigationController: AppNavigationController? = .init()
    var primaryViewController: UIViewController { .init() }
}

private extension App {

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }

        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: - Coordinator

extension App: Coordinator {

    func start() {
        registerForPushNotifications()

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
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - DeepLink

extension App {
    
    func handleDeepLink(_ url: URL) {
        guard let deepLink = parser.parse(url: url) else { return }

        navigator.resolveAndNavigate(deepLink)
    }
}
