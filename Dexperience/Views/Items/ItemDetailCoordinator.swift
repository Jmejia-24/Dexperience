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
    private var stringUrl: String

    private lazy var itemDetailViewModel: ItemDetailViewModel = {
        ItemDetailViewModel(router: router, stringUrl: stringUrl)
    }()

    lazy var primaryViewController: UIViewController = {
        return ItemDetailViewController(viewModel: itemDetailViewModel)
    }()

    // MARK: - Initializers

    init(router: R, stringUrl: String) {
        self.router = router
        self.stringUrl = stringUrl
    }
}

// MARK: - Coordinator

extension ItemDetailCoordinator: Coordinator {

    func start() {
        primaryViewController.modalPresentationStyle = .fullScreen

        router.navigationController?.present(primaryViewController, animated: true)
    }
}
