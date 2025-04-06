//
//  ItensCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class ItensCoordinator<R: AppRouter> {

    // MARK: - Properties

    private var router: R
    private var settingsNavigationController: AppNavigationController!

    lazy var primaryViewController: UIViewController = {
        let viewController = ItensViewController()

        settingsNavigationController = AppNavigationController(rootViewController: viewController)

        return viewController
    }()

    // MARK: - Initializers

    init(router: R) {
        self.router = router
    }
}

// MARK: - Coordinator

extension ItensCoordinator: Coordinator {

    func start() {

    }
}

// MARK: - Router

extension ItensCoordinator: ItensRouter {

    var navigationController: AppNavigationController {
        get { settingsNavigationController }
        set { }
    }

    func process(route: ItensTransition) {

    }

    func exit() {

    }
}
