//
//  PokemonsTransition.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

enum PokemonsTransition {

    case pokemonDetail(String)

    var identifier: String {
        String(describing: self)
    }

    func coordinatorFor<R: PokemonsRouter>(router: R) -> Coordinator {
        return switch self {
        case .pokemonDetail(let pokemonPath):
            PokemonDetailCoordinator(router: router, pokemonPath: pokemonPath)
        }
    }
}
