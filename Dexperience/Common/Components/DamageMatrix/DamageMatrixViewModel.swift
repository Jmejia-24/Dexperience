//
//  DamageMatrixViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

import Foundation

final class DamageMatrixViewModel {

    private let api: PokemonsRepository
    private let types: [TypeElement]
    private let mode: DamageTypeMode

    private(set) var data: [PokemonType: Double] = [:]

    let columns = 3

    init(types: [TypeElement], mode: DamageTypeMode, api: PokemonsRepository = APIManager()) {
        self.types = types
        self.mode = mode
        self.api = api
    }

    func loadDamageRelations() async throws {
        let types = types.compactMap({ URL(string: $0.type?.url ?? "") })

        data = try await combinedDamageRelations(for: types)
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

private extension DamageMatrixViewModel {

    func combinedDamageRelations(for urls: [URL]) async throws -> [PokemonType: Double] {
        var multipliers = Dictionary(uniqueKeysWithValues: PokemonType.allCases.map { ($0, 1.0) })

        for url in urls {
            let type = try await api.pokemonType(url: url)
            let damage = type.damageRelations

            switch mode {
            case .offensive:
                updateMultipliers(from: damage.doubleDamageTo, multiplier: 2.0, into: &multipliers)
                updateMultipliers(from: damage.halfDamageTo, multiplier: 0.5, into: &multipliers)
                updateMultipliers(from: damage.noDamageTo, multiplier: 0.0, into: &multipliers)
            case .defensive:
                updateMultipliers(from: damage.doubleDamageFrom, multiplier: 2.0, into: &multipliers)
                updateMultipliers(from: damage.halfDamageFrom, multiplier: 0.5, into: &multipliers)
                updateMultipliers(from: damage.noDamageFrom, multiplier: 0.0, into: &multipliers)
            }
        }

        return multipliers
    }

    func updateMultipliers(from damages: [PokemonSummary]?, multiplier: Double, into dict: inout [PokemonType: Double]) {
        damages?.forEach {
            if let name = $0.name, let type = PokemonType(rawValue: name) {
                dict[type, default: 1.0] *= multiplier == 0 ? 0 : multiplier
            }
        }
    }
}
