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

    private(set) var shortEffect: String = ""

    init(entry: AbilityEntry, api: PokemonsRepository = APIManager()) {
        self.entry = entry
        self.api = api
    }

    func loadAbilityDescription() async throws {
        guard let urlString = entry.ability?.url,
              let url = URL(string: urlString) else { return }

        let ability = try await api.fetchAbility(url: url)

        shortEffect = ability.effectEntries?.first(where: { $0.language?.name == .en })?.shortEffect ?? ""
    }
}
