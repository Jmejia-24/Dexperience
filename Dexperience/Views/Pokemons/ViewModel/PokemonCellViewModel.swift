//
//  PokemonCellViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class PokemonCellViewModel {

    // MARK: - Properties

    private let api: PokemonsRepository
    private let pokemonPath: String?

    // MARK: - Initializer

    init(pokemonPath: String?, api: PokemonsRepository = APIManager()) {
        self.pokemonPath = pokemonPath
        self.api = api
    }

    func fetchDetails() async throws -> Pokemon? {
        guard let pokemonPath else { return nil }

        return try await api.fetchPokemon(from: pokemonPath)
    }
}
