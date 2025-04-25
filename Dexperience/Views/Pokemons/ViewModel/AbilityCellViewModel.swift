//
//  AbilityCellViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import Foundation

final class AbilityCellViewModel {

    private let entry: AbilityEntry
    private let api: PokemonsRepository

    var name: String {
        entry.ability?.name?.capitalized ?? "-"
    }

    var isHidden: Bool {
        entry.isHidden ?? false
    }

    init(entry: AbilityEntry, api: PokemonsRepository = APIManager()) {
        self.entry = entry
        self.api = api
    }

    func loadAbilityDescription() async throws -> String? {
        guard let abilityPath = entry.ability?.url?.lastPathComponent else { return nil }

        let ability = try await api.fetchAbility(from: abilityPath)

        return ability.effectEntries?.first(where: { $0.language?.name == .en })?.shortEffect ?? ""
    }
}
