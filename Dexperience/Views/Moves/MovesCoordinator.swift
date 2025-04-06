//
//  MovesCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class MovesCoordinator<R: AppRouter> {

    // MARK: - Properties

    private var router: R
    private var favoritesNavigationController: AppNavigationController!

    lazy var primaryViewController: UIViewController = {
        let viewController = MovesViewController()

        favoritesNavigationController = AppNavigationController(rootViewController: viewController)

        return viewController
    }()

    // MARK: - Initializers

    init(router: R) {
        self.router = router
    }
}

// MARK: - Coordinator

extension MovesCoordinator: Coordinator {

    func start() {

    }
}

// MARK: - Router

extension MovesCoordinator: MovesRouter {

    var navigationController: AppNavigationController {
        get { favoritesNavigationController }
        set { }
    }

    func process(route: MovesTransition) { }

    func exit() { }
}
