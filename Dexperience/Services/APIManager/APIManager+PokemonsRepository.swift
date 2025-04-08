//
//  APIManager+PokemonsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

extension APIManager: PokemonsRepository {

    func fetchPokemonList(offset: Int) async throws -> PokemonListResponse {
        let request = Request(
            endpoint: .pokemon,
            queryParameters: [
                .init(name: "limit", value: "50"),
                .init(name: "offset", value: "\(offset)")
            ],
        )

        return try await execute(request)
    }

    func fetchPokemon(url: URL) async throws -> Pokemon {
        let request = Request(with: url)

        return try await execute(request)
    }
}
