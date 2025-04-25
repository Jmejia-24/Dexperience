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
        guard let movePath = pokemonMove.move?.url?.lastPathComponent else { return }

        let move = try? await api.fetchMove(from: movePath)

        type = PokemonType(rawValue: move?.type?.name ?? "")
    }
}
