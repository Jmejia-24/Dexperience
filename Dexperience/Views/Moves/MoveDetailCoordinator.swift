//
//  MoveDetailCoordinator.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

import UIKit

final class MoveDetailCoordinator<R: MovesRouter> {

    // MARK: - Properties

    private var router: R
    private var movePath: String

    private lazy var moveDetailViewModel: MoveDetailViewModel = {
        MoveDetailViewModel(router: router, movePath: movePath)
    }()

    lazy var primaryViewController: UIViewController = {
        return MoveDetailViewController(viewModel: moveDetailViewModel)
    }()

    // MARK: - Initializers

    init(router: R, movePath: String) {
        self.router = router
        self.movePath = movePath
    }
}

// MARK: - Coordinator

extension MoveDetailCoordinator: Coordinator {

    func start() {
        primaryViewController.modalPresentationStyle = .fullScreen

        safePresent(from: router.navigationController, viewController: primaryViewController)
    }
}
