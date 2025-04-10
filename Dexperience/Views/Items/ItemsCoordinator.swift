//
//  ItemsCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class ItemsCoordinator<R: AppRouter> {

    // MARK: - Properties

    private var router: R
    private var settingsNavigationController: AppNavigationController!

    private lazy var itemsViewModel: ItemsViewModel = {
        ItemsViewModel(router: self)
    }()


    lazy var primaryViewController: UIViewController = {
        let viewController = ItemsViewController(viewModel: itemsViewModel)

        settingsNavigationController = AppNavigationController(rootViewController: viewController)

        return viewController
    }()

    // MARK: - Initializers

    init(router: R) {
        self.router = router
    }
}

// MARK: - Coordinator

extension ItemsCoordinator: Coordinator {

    func start() {

    }
}

// MARK: - Router

extension ItemsCoordinator: ItemsRouter {

    var navigationController: AppNavigationController {
        get { settingsNavigationController }
        set { }
    }

    func process(route: ItemsTransition) {

    }

    func exit() {

    }
}
