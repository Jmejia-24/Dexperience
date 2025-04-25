//
//  DeepLinkRouteResolver.swift
//  Dexperience
//
//  Created by Byron on 4/24/25.
//

import Foundation

final class DeepLinkRouteResolver: DeepLinkRouteResolving {

    func appTransition(for deepLink: DeepLink) -> AppTransition? {
        return switch deepLink {
        case .tab: .showTabBar
        case .pokemonDetail, .moveDetail, .itemDetail: .showTabBar
        }
    }

    func tabFor(_ deepLink: DeepLink) -> TabBarTransition? {
        return switch deepLink {
        case .tab(let tab):
            tab
        case .pokemonDetail: .showPokemons
        case .moveDetail: .showMoves
        case .itemDetail: .showItems
        }
    }
}
