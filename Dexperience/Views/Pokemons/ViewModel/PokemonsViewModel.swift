//
//  PokemonsViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import Foundation

final class PokemonsViewModel<R: PokemonsRouter> {

    // MARK: - Properties

    private let router: R
    private let api: PokemonsRepository
    private var pokemonListResponse: PokemonListResponse?

    var pokemonList: [PokemonSummary] = []

    // MARK: - Initializers

    init(router: R, api: PokemonsRepository = APIManager()) {
        self.router = router
        self.api = api
    }

    @MainActor
    func getPokemonList() async throws {
        let response = try await api.fetchPokemonList(offset: 0)

        pokemonListResponse = response
        pokemonList = response.results
    }

    func searchPokemon(with query: String?) -> [PokemonSummary] {
        guard let query = query?.lowercased(), !query.isEmpty else {
            return pokemonList
        }

        return pokemonList.filter { pokemon in
            pokemon.name?.lowercased().contains(query) ?? false
        }
    }
}

// MARK: - Navigation

extension PokemonsViewModel {

}
