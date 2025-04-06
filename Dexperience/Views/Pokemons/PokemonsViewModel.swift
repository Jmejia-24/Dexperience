//
//  PokemonsViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

final class PokemonsViewModel<R: PokemonsRouter> {

    // MARK: - Properties

    private let router: R

    // MARK: - Initializers

    init(router: R) {
        self.router = router
    }
}

// MARK: - Navigation

extension PokemonsViewModel {

}
