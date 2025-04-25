//
//  MoveCellViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import UIKit

final class MoveCellViewModel {

    // MARK: - Properties

    private let api: MovesRepository
    private let movePath: String?

    private(set) var move: Move?
    private(set) var type: PokemonType?

    // MARK: - Initializer

    init(movePath: String?, api: MovesRepository = APIManager()) {
        self.movePath = movePath
        self.api = api
    }

    func fetchDetails() async {
        guard let movePath else { return }

        move = try? await api.fetchMove(from: movePath)

        type = PokemonType(rawValue: move?.type?.name ?? "")
    }
}
