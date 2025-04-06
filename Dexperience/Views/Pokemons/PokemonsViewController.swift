//
//  PokemonsViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class PokemonsViewController<R: PokemonsRouter>: UICollectionViewController, UISearchResultsUpdating {

    // MARK: - Properties

    private let viewModel: PokemonsViewModel<R>

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        return searchController
    }()

    // MARK: - Initializers

    init(viewModel: PokemonsViewModel<R>) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: Self.makeListLayout())

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func updateSearchResults(for searchController: UISearchController) {

    }
}

// MARK: - Private methods

private extension PokemonsViewController {

    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

    func setupUI() {
        title = "Pokemon"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
