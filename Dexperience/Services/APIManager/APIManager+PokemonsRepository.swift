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

    func pokemonType(from path: String) async throws -> TypeResponse {
        let request = Request(
            endpoint: .type,
            pathComponents: [path]
        )

        return try await execute(request)
    }

    func fetchSpecie(from path: String) async throws -> Specie {
        let request = Request(
            endpoint: .pokemonSpecies,
            pathComponents: [path]
        )

        return try await execute(request)
    }

    func fetchEvolutionChain(from path: String) async throws -> EvolutionChainResponse {
        let request = Request(
            endpoint: .evolutionChain,
            pathComponents: [path]
        )

        return try await execute(request)
    }

    func fetchPokemon(from path: String) async throws -> Pokemon {
        let request = Request(
            endpoint: .pokemon,
            pathComponents: [path]
        )

        return try await execute(request)
    }

    func fetchAbility(from path: String) async throws -> Ability {
        let request = Request(
            endpoint: .ability,
            pathComponents: [path]
        )

        return try await execute(request)
    }
}
