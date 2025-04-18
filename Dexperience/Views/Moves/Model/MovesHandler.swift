//
//  MovesHandler.swift
//  Dexperience
//
//  Created by Byron on 4/18/25.
//

import UIKit

final class MovesHandler<R: MovesRouter>: GenericListHandler {

    typealias Model = PokemonSummary

    private let viewModel: MovesViewModel<R>

    init(viewModel:  MovesViewModel<R>) {
        self.viewModel = viewModel
    }

    var title: String { "Moves" }

    func fetchInitialData() async throws -> [Model] {
        try await viewModel.getMoveList()

        return viewModel.moveList
    }

    func search(query: String?) -> [Model] {
        viewModel.searchMove(with: query)
    }

    func prefetch(at indexPaths: [IndexPath]) async throws -> [Model] {
        let count = viewModel.moveList.count

        if indexPaths.contains(where: { $0.item >= count - 10 }) {
            try await viewModel.fetchMoreMoves()
        }

        return viewModel.moveList
    }

    func didSelect(item model: Model) {
        viewModel.showDetail(model)
    }

    func contextMenu(for indexPath: IndexPath, item: Model) -> UIContextMenuConfiguration? {
        nil
    }
}
