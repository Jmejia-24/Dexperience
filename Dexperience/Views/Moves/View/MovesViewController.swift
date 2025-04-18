//
//  MovesViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class MovesViewController<R: MovesRouter>: GenericListViewController<MoveCellView, MovesHandler<R>> {

    init(viewModel: MovesViewModel<R>) {
        let handler = MovesHandler(viewModel: viewModel)

        let registration = UICollectionView.CellRegistration<MoveCellView, PokemonSummary> { cell, _, item in
            let cellViewModel = MoveCellViewModel(stringUrl: item.url)

            cell.configure(with: cellViewModel)
        }

        super.init(handler: handler, cellRegistration: registration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
