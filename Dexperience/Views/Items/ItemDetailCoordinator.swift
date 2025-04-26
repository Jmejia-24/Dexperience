//
//  ItemDetailCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import UIKit

final class ItemDetailCoordinator<R: ItemsRouter> {

    // MARK: - Properties

    private var router: R
    private var itemPath: String

    private lazy var itemDetailViewModel: ItemDetailViewModel = {
        ItemDetailViewModel(router: router, itemPath: itemPath)
    }()

    lazy var primaryViewController: UIViewController = {
        return ItemDetailViewController(viewModel: itemDetailViewModel)
    }()

    // MARK: - Initializers

    init(router: R, itemPath: String) {
        self.router = router
        self.itemPath = itemPath
    }
}

// MARK: - Coordinator

extension ItemDetailCoordinator: Coordinator {

    func start() {
        primaryViewController.modalPresentationStyle = .fullScreen

        safePresent(from: router.navigationController, viewController: primaryViewController)
    }
}
