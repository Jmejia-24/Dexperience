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
    private var movesNavigationController: AppNavigationController?

    private lazy var movesViewModel: MovesViewModel = {
        MovesViewModel(router: self)
    }()

    lazy var primaryViewController: UIViewController = {
        let viewController = MovesViewController(viewModel: movesViewModel)

        movesNavigationController = AppNavigationController(rootViewController: viewController)

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

    var navigationController: AppNavigationController? {
        get { movesNavigationController }
        set { }
    }

    func process(route: MovesTransition) { }

    func exit() { }
}
