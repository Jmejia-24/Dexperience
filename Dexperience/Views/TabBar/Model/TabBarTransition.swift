//
//  TabBarTransition.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

enum TabBarTransition: Int, CaseIterable {

    case showPokemons
    case showMoves
    case showItems

    var identifier: String {
        String(describing: self)
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: title,
            image: image,
            tag: self.rawValue
        )
    }

    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
        case .showPokemons: PokemonsCoordinator(router: router)
        case .showMoves: MovesCoordinator(router: router)
        case .showItems: ItemsCoordinator(router: router)
        }
    }
}

private extension TabBarTransition {

    var iconResource: ImageResource {
        switch self {
        case .showPokemons: .pokemonIcon
        case .showMoves: .movesIcon
        case .showItems: .itemsIcon
        }
    }

    var title: String {
        switch self {
        case .showPokemons: "Pokémon"
        case .showMoves: "Moves"
        case .showItems: "Items"
        }
    }

    var image: UIImage? {
        UIImage(resource: iconResource)
    }
}
