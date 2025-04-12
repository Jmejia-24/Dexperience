//
//  MoveDetailViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

import Foundation

final class MoveDetailViewModel<R: MovesRouter> {

    // MARK: - Properties

    private let router: R
    private let api: MovesRepository
    private let moveURL: String?

    let containerTopConstraintConstant: CGFloat = 58
    var move: Move?
    var moveType: PokemonType?
    var infoList = [String]()

    // MARK: - Initializers

    init(router: R, api: MovesRepository = APIManager(), stringUrl: String?) {
        self.router = router
        self.api = api
        self.moveURL = stringUrl
    }

    // MARK: - Data Fetching

    @MainActor
    func fetchDetails() async throws {
        guard let moveURL,
              let url = URL(string: moveURL) else { return }

        let moveResponse = try await api.fetchMove(url: url)

        move = moveResponse

        if let typeName = moveResponse.type?.name {
            moveType = PokemonType(rawValue: typeName)
        }

        infoList = moveResponse.effectEntries?.compactMap { $0.effect } ?? []
    }
}
