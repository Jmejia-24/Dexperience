//
//  PokemonPreviewViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import UIKit

final class PokemonPreviewViewModel {

    private let api: PokemonsRepository
    private let pokemonURL: URL

    private(set) var pokemon: Pokemon?
    private(set) var offensiveData: [PokemonType: Double] = [:]

    let columns = 3

    init(pokemonURL: URL, api: PokemonsRepository = APIManager()) {
        self.pokemonURL = pokemonURL
        self.api = api
    }

    func loadData() async throws {
        pokemon = try await api.fetchPokemon(url: pokemonURL)

        if let pokemonTypesUrls = pokemon?.types?.compactMap({ URL(string: $0.type?.url ?? "") }) {
            offensiveData = try await combinedDamageRelationsOffensive(for: pokemonTypesUrls)
        }
    }

    func formatMultiplier(_ value: Double) -> String {
        let rounded = (value * 100).rounded() / 100
        switch rounded {
        case 2.0:
            return "2x"
        case 0.5:
            return "1/2x"
        case 0.0:
            return "0x"
        default:
            return "\(Int(rounded))x"
        }
    }
}

private extension PokemonPreviewViewModel {

    func combinedDamageRelationsOffensive(for pokemonTypesUrls: [URL]) async throws -> [PokemonType: Double] {
        var offensiveMultipliers = Dictionary(uniqueKeysWithValues: PokemonType.allCases.map { ($0, 1.0) })

        for url in pokemonTypesUrls {
            let typeResponse = try await api.pokemonType(url: url)
            let damage = typeResponse.damageRelations

            updateMultipliers(from: damage.doubleDamageTo, multiplier: 2.0, in: &offensiveMultipliers)
            updateMultipliers(from: damage.halfDamageTo, multiplier: 0.5, in: &offensiveMultipliers)
            updateMultipliers(from: damage.noDamageTo, multiplier: 0, in: &offensiveMultipliers)
        }

        return offensiveMultipliers
    }

    func updateMultipliers(from damages: [PokemonSummary]?, multiplier: Double, in dictionary: inout [PokemonType: Double]) {
        guard let damages else { return }

        damages.forEach {
            if let name = $0.name, let type = PokemonType(rawValue: name) {
                if multiplier == 0 {
                    dictionary[type] = 0
                } else {
                    dictionary[type, default: 1.0] *= multiplier
                }
            }
        }
    }
}
