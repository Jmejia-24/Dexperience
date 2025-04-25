//
//  PokemonDetailCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/12/25.
//

import UIKit

final class PokemonDetailCoordinator<R: PokemonsRouter> {

    // MARK: - Properties

    private var router: R
    private var pokemonPath: String

    private lazy var pokemonDetailViewModel: PokemonDetailViewModel = {
        PokemonDetailViewModel(router: router, pokemonPath: pokemonPath)
    }()

    lazy var primaryViewController: UIViewController = {
        return PokemonDetailViewController(viewModel: pokemonDetailViewModel)
    }()

    // MARK: - Initializers

    init(router: R, pokemonPath: String) {
        self.router = router
        self.pokemonPath = pokemonPath
    }
}

// MARK: - Coordinator

extension PokemonDetailCoordinator: Coordinator {

    func start() {
        primaryViewController.modalPresentationStyle = .fullScreen

        safePresent(from: router.navigationController, viewController: primaryViewController)
    }
}
