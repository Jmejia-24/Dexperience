//
//  PokemonsCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class PokemonsCoordinator<R: AppRouter> {

    // MARK: - Properties

    private var router: R
    private var pokemonsNavigationController: AppNavigationController!

    private lazy var pokemonsViewModel: PokemonsViewModel = {
        PokemonsViewModel(router: self)
    }()

    lazy var primaryViewController: UIViewController = {
        let viewController = PokemonsViewController(viewModel: pokemonsViewModel)

        pokemonsNavigationController = AppNavigationController(rootViewController: viewController)

        return viewController
    }()

    // MARK: - Initializers

    init(router: R) {
        self.router = router
    }
}

// MARK: - Coordinator

extension PokemonsCoordinator: Coordinator {

    func start() { }
}

// MARK: - Router

extension PokemonsCoordinator: PokemonsRouter {

    var navigationController: AppNavigationController? {
        get { pokemonsNavigationController }
        set { }
    }

    func process(route: PokemonsTransition) {
    }

    func exit() { }
}
