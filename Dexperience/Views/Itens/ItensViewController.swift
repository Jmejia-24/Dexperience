//
//  ItensViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class ItensViewController: UICollectionViewController, UISearchResultsUpdating {

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        return searchController
    }()
    
    // MARK: - Initializers

    init() {
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

private extension ItensViewController {

    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

    func setupUI() {
        title = "Itens"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
