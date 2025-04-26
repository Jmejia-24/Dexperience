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
    private let movePath: String?

    let containerTopConstraintConstant: CGFloat = 58
    let headerTopConstraintConstant: CGFloat = 30
    
    var isHeaderHidden = false

    var move: Move?
    var moveType: PokemonType?
    var infoList = [String]()

    var moveDeepLink: URL? {
        guard let movePath else { return nil }

        return URL(string: "dexperience://tab/moves/\(movePath)")
    }

    // MARK: - Initializers

    init(router: R, api: MovesRepository = APIManager(), movePath: String?) {
        self.router = router
        self.api = api
        self.movePath = movePath
    }

    // MARK: - Data Fetching

    @MainActor
    func fetchDetails() async throws {
        guard let movePath else { return }

        let moveResponse = try await api.fetchMove(from: movePath)

        move = moveResponse

        if let typeName = moveResponse.type?.name {
            moveType = PokemonType(rawValue: typeName)
        }

        infoList = moveResponse.effectEntries?.compactMap { $0.effect } ?? []
    }
}
