//
//  APIManager+PokemonsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

extension APIManager: PokemonsRepository {

    func fetchPokemonList(from url: URL?) async throws -> PokemonListResponse {
        var request: Request
        
        if let url {
            request = Request(with: url)
        } else {
            request = Request(
                endpoint: .pokemon,
                queryParameters: [
                    .init(name: "limit", value: "50")
                ],
            )
        }
        
        return try await execute(request)
    }

    func fetchPokemon(url: URL) async throws -> Pokemon {
        let request = Request(with: url)

        return try await execute(request)
    }
}
