//
//  AppTransition.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

enum AppTransition {

    case showTabBar

    var identifier: String {
        String(describing: self)
    }

    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        return switch self {
            case .showTabBar: TabBarCoordinator(router: router)
        }
    }
}
