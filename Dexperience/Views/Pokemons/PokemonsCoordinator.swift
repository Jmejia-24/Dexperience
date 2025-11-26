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
    private var pokemonsNavigationController: UINavigationController!

    private lazy var pokemonsViewModel: PokemonsViewModel = {
        PokemonsViewModel(router: self)
    }()

    lazy var primaryViewController: UIViewController = {
        let viewController = PokemonsViewController(viewModel: pokemonsViewModel)

        pokemonsNavigationController = UINavigationController(rootViewController: viewController)

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

    var navigationController: UINavigationController? {
        get { pokemonsNavigationController }
        set { }
    }

    func process(route: PokemonsTransition) {
#if DEBUG

        let routeInfo = """
        🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍\n
        🟢🚀 Processing Route 🟢🚀
        🛣️ Route Identifier: \(route.identifier)
        \n🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚\n
        """

        print(routeInfo)

#endif

        let coordinator = route.coordinatorFor(router: self)

        coordinator.start()
    }

    func exit() { }
}

// MARK: - DeepLink

extension PokemonsCoordinator: DeepLinkHandleable {

    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .pokemonDetail(let id):
            process(route: .pokemonDetail(id))
        default:
            break
        }
    }
}
