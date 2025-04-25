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
    private var isFetchingMore = false

    var pokemonList: [PokemonSummary] = []

    // MARK: - Initializers

    init(router: R, api: PokemonsRepository = APIManager()) {
        self.router = router
        self.api = api
    }

    @MainActor
    func getPokemonList() async throws {
        let response = try await api.fetchPokemonList(from: nil)

        pokemonListResponse = response
        pokemonList = response.results
    }

    @MainActor
    func fetchMorePokemon() async throws {
        guard !isFetchingMore,
              let nextUrlString = pokemonListResponse?.next,
              let nextUrl = URL(string: nextUrlString) else { return }

        isFetchingMore = true

        let response = try await api.fetchPokemonList(from: nextUrl)
        pokemonListResponse = response

        pokemonList.append(contentsOf: response.results)
        isFetchingMore = false
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

    func showDetail(_ item: PokemonSummary) {
        guard let pokemonPath = item.url?.lastPathComponent else { return }

        router.process(route: .pokemonDetail(pokemonPath))
    }
}
