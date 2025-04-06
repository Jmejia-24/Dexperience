//
//  TabBarViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

final class TabBarViewModel<R: TabBarRouter> {

    // MARK: - Properties

    private let router: R

    var tabBarGradientApplied = false

    // MARK: - Initializers

    init(router: R) {
        self.router = router
    }
}

// MARK: - Navegation

extension TabBarViewModel {

    func didSelect(tag: Int) {
        guard let transition = TabBarTransition(rawValue: tag) else { return }

        router.process(route: transition)
    }
}
