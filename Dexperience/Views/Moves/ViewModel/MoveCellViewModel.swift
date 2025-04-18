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
    private let moveURL: String?

    private(set) var move: Move?
    private(set) var type: PokemonType?

    // MARK: - Initializer

    init(stringUrl: String?, api: MovesRepository = APIManager()) {
        self.moveURL = stringUrl
        self.api = api
    }

    func fetchDetails() async {
        guard let moveURL,
              let url = URL(string: moveURL) else { return }

        move = try? await api.fetchMove(url: url)

        type = PokemonType(rawValue: move?.type?.name ?? "")
    }
}
