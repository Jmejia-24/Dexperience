//
//  PokemonsHandler.swift
//  Dexperience
//
//  Created by Byron on 4/18/25.
//

import UIKit

final class PokemonsHandler<R: PokemonsRouter>: GenericListHandler {

    typealias Model = PokemonSummary

    let viewModel: PokemonsViewModel<R>

    init(viewModel: PokemonsViewModel<R>) {
        self.viewModel = viewModel
    }

    var title: String { "Pokémon" }

    func fetchInitialData() async throws -> [Model] {
        try await viewModel.getPokemonList()

        return viewModel.pokemonList
    }

    func search(query: String?) async -> [Model] {
        viewModel.searchPokemon(with: query)
    }

    func prefetch(at indexPaths: [IndexPath]) async throws -> [Model] {
        let count = viewModel.pokemonList.count

        if indexPaths.contains(where: { $0.item >= count - 10 }) {
            try await viewModel.fetchMorePokemon()
        }

        return viewModel.pokemonList
    }

    func didSelect(item: Model) {
        viewModel.showDetail(item)
    }

    func contextMenu(for indexPath: IndexPath, item: Model) -> UIContextMenuConfiguration? {
        guard let pokemonPath = item.url?.lastPathComponent else { return nil }

        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: {
                let pokemonPreviewViewModel = PokemonPreviewViewModel(pokemonPath: pokemonPath)

                return PokemonPreview(viewModel: pokemonPreviewViewModel)
            },
            actionProvider: nil
        )
    }
}
