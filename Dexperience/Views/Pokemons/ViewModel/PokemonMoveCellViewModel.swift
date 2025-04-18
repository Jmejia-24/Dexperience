//
//  PokemonMoveCellViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/14/25.
//

import Foundation

final class PokemonMoveCellViewModel {

    // MARK: - Properties

    private let api: MovesRepository

    private(set) var pokemonMove: LearnableMove
    private(set) var type: PokemonType?

    // MARK: - Initializer

    init(pokemonMove: LearnableMove, api: MovesRepository = APIManager()) {
        self.pokemonMove = pokemonMove
        self.api = api
    }

    func fetchDetails() async {
        guard let moveURL = pokemonMove.move?.url,
              let url = URL(string: moveURL) else { return }

        let move = try? await api.fetchMove(url: url)

        type = PokemonType(rawValue: move?.type?.name ?? "")
    }
}
