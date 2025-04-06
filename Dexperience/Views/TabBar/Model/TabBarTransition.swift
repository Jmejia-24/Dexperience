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
    case showItens

    var identifier: String {
        String(describing: self)
    }

    var image: UIImage? {
        return switch self {
        case .showPokemons:
            UIImage(resource: .pokemonIcon)
        case .showMoves:
            UIImage(resource: .movesIcon)
        case .showItens:
            UIImage(resource: .itensIcon)
        }
    }

    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        return switch self {
            case .showPokemons: PokemonsCoordinator(router: router)
            case .showMoves: MovesCoordinator(router: router)
            case .showItens: ItensCoordinator(router: router)
        }
    }
}
