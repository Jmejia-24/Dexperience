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

    func pokemonType(url: URL) async throws -> TypeResponse {
        let request = Request(with: url)

        return try await execute(request)
    }

    func fetchSpecie(url: URL) async throws -> Specie {
        let request = Request(with: url)

        return try await execute(request)
    }

    func fetchEvolutionChain(url: URL) async throws -> EvolutionChainResponse {
        let request = Request(with: url)

        return try await execute(request)
    }

    func fetchPokemon(from name: String) async throws -> Pokemon {
        let request = Request(
            endpoint: .pokemon,
            pathComponents: [
                name
            ],
        )

        return try await execute(request)
    }

    func fetchAbility(url: URL) async throws -> Ability {
        let request = Request(with: url)

        return try await execute(request)
    }
}
