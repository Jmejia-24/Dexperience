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
    private var stringUrl: String

    private lazy var pokemonDetailViewModel: PokemonDetailViewModel = {
        PokemonDetailViewModel(router: router, stringUrl: stringUrl)
    }()

    lazy var primaryViewController: UIViewController = {
        return PokemonDetailViewController(viewModel: pokemonDetailViewModel)
    }()

    // MARK: - Initializers

    init(router: R, stringUrl: String) {
        self.router = router
        self.stringUrl = stringUrl
    }
}

// MARK: - Coordinator

extension PokemonDetailCoordinator: Coordinator {

    func start() {
        primaryViewController.modalPresentationStyle = .fullScreen

        router.navigationController?.present(primaryViewController, animated: true)
    }
}
