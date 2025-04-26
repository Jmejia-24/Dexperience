//
//  ItemsViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class ItemsViewController<R: ItemsRouter>: GenericListViewController<ItemCellView, ItemsHandler<R>> {

    init(viewModel: ItemsViewModel<R>) {
        let handler = ItemsHandler(viewModel: viewModel)

        let registration = UICollectionView.CellRegistration<ItemCellView, PokemonSummary> { cell, _, item in
            let cellViewModel = ItemCellViewModel(itemPath: item.url?.lastPathComponent)

            cell.configure(with: cellViewModel)
        }

        super.init(handler: handler, cellRegistration: registration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
