//
//  DeepLinkNavigator.swift
//  Dexperience
//
//  Created by Byron on 4/24/25.
//

final class DeepLinkNavigator<R: AppRouter> {

    private let router: R
    private let resolver: DeepLinkRouteResolving

    init(router: R, resolver: DeepLinkRouteResolving = DeepLinkRouteResolver()) {
        self.router = router
        self.resolver = resolver
    }

    func resolveAndNavigate(_ deepLink: DeepLink) {
        guard let transition = resolver.appTransition(for: deepLink) else { return }

        router.process(route: transition)

        guard let tab = resolver.tabFor(deepLink) else { return }

        select(tab: tab)
        delegateToCoordinator(for: tab, deepLink: deepLink)
    }
}

private extension DeepLinkNavigator {

    func select(tab: TabBarTransition) {
        guard let tabBarViewController = router.navigationController?.viewControllers
                .compactMap({ $0 as? TabBarViewController<TabBarCoordinator<R>> }).first
        else { return }

        tabBarViewController.selectedIndex = tab.rawValue
        tabBarViewController.viewModel.didSelect(tag: tab.rawValue)
    }

    func delegateToCoordinator(for tab: TabBarTransition, deepLink: DeepLink) {
        guard let tabBarViewController = router.navigationController?.viewControllers
                .compactMap({ $0 as? TabBarViewController<TabBarCoordinator<R>> }).first,
              let coordinator = tabBarViewController.viewModel.router.coordinatorRegister[tab] as? DeepLinkHandleable
        else { return }

        coordinator.handle(deepLink: deepLink)
    }
}
