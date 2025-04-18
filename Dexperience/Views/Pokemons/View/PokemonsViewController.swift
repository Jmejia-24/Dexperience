//
//  PokemonsViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class PokemonsViewController<R: PokemonsRouter>: GenericListViewController<PokemonCellView, PokemonsHandler<R>> {

    init(viewModel: PokemonsViewModel<R>) {
        let handler = PokemonsHandler(viewModel: viewModel)

        let registration = UICollectionView.CellRegistration<PokemonCellView, PokemonSummary> { cell, _, item in
            let cellViewModel = PokemonCellViewModel(stringUrl: item.url)

            cell.configure(with: cellViewModel)
        }

        super.init(handler: handler, cellRegistration: registration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
