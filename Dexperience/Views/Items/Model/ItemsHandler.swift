//
//  ItemsHandler.swift
//  Dexperience
//
//  Created by Byron on 4/18/25.
//

import UIKit

final class ItemsHandler<R: ItemsRouter>: GenericListHandler {

    typealias Model = PokemonSummary

    private let viewModel: ItemsViewModel<R>

    init(viewModel: ItemsViewModel<R>) {
        self.viewModel = viewModel
    }

    var title: String { "Items" }

    func fetchInitialData() async throws -> [Model] {
        try await viewModel.getItemList()

        return viewModel.itemList
    }

    func search(query: String?) async -> [Model] {
        viewModel.searchMove(with: query)
    }

    func prefetch(at indexPaths: [IndexPath]) async throws -> [Model] {
        let count = viewModel.itemList.count

        if indexPaths.contains(where: { $0.item >= count - 10 }) {
            try await viewModel.fetchMoreItems()
        }

        return viewModel.itemList
    }

    func didSelect(item model: Model) {
        viewModel.showDetail(model)
    }

    func contextMenu(for indexPath: IndexPath, item: Model) -> UIContextMenuConfiguration? {
        nil
    }
}
