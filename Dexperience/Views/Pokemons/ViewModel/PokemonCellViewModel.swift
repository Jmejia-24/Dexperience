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
    private let pokemonURL: String?

    // MARK: - Initializer

    init(stringUrl: String?, api: PokemonsRepository = APIManager()) {
        self.pokemonURL = stringUrl
        self.api = api
    }

    func fetchDetails() async throws -> Pokemon? {
        guard let pokemonURL,
              let url = URL(string: pokemonURL) else { return nil }

        return try await api.fetchPokemon(url: url)
    }
}
