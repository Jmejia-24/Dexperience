//
//  TabBarCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

final class TabBarCoordinator<R: AppRouter> {

    // MARK: - Properties

    private var coordinatorRegister: [TabBarTransition: Coordinator] = [:]

    var navigationController: AppNavigationController {
        get { router.navigationController }
        set { router.navigationController = newValue }
    }

    private var router: R

    private lazy var tabBarViewModel: TabBarViewModel = {
        TabBarViewModel(router: self)
    }()

    lazy var primaryViewController: UIViewController = {
        let tabBarViewController: TabBarViewController = .init(viewModel: tabBarViewModel)

        let navigationControllers = TabBarTransition.allCases.map { (transition: TabBarTransition) -> UINavigationController in
            coordinatorRegister[transition] = transition.coordinatorFor(router: router)
            coordinatorRegister[transition]?.primaryViewController.tabBarItem.image = transition.image

            guard let router = coordinatorRegister[transition] as? any Router else { fatalError() }

            return router.navigationController
        }

        tabBarViewController.setViewControllers(navigationControllers, animated: true)

        return tabBarViewController
    }()

    // MARK: - Initializer

    init(router: R) {
        self.router = router
    }
}

// MARK: - Coordinator

extension TabBarCoordinator: Coordinator {

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)

        navigationController.pushViewController(primaryViewController, animated: true)
    }
}

// MARK: - TabBar Coordinator

extension TabBarCoordinator: TabBarRouter {

    func process(route: TabBarTransition) {
        coordinatorRegister[route]?.start()
    }

    func exit() {
        navigationController.popViewController(animated: true)
    }
}
