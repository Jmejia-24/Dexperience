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

    private(set) var pokemon: Pokemon?

    var onUpdate: (() -> Void)?

    // MARK: - Initializer

    init(stringUrl: String?, api: PokemonsRepository = APIManager()) {
        self.pokemonURL = stringUrl
        self.api = api

        Task { @MainActor in
            await fetchDetails()
        }
    }
}

private extension PokemonCellViewModel {

    // MARK: - Data Fetching

    func fetchDetails() async {
        guard let pokemonURL,
              let url = URL(string: pokemonURL) else { return }

        do {
            pokemon = try await api.fetchPokemon(url: url)

            onUpdate?()
        } catch {
            onUpdate?()
        }
    }
}
