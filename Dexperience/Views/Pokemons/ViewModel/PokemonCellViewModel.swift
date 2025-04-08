//
//  PokemonCellViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class PokemonCellViewModel {

    // MARK: - Properties

    private let api: PokemonsRepository
    private let pokemonURL: String?

    private(set) var name: String = ""
    private(set) var idText: String = ""
    private(set) var imageUrl: URL?
    private(set) var typeImages: [UIImage] = []

    var onUpdate: (() -> Void)?

    // MARK: - Initializer

    init(stringUrl: String?, api: PokemonsRepository = APIManager()) {
        self.pokemonURL = stringUrl
        self.api = api

        Task { @MainActor in
            await fetchDetails()
        }
    }
}

private extension PokemonCellViewModel {

    // MARK: - Data Fetching

    func fetchDetails() async {
        guard let pokemonURL,
              let url = URL(string: pokemonURL) else { return }

        do {
            let pokemon = try await api.fetchPokemon(url: url)

            name = pokemon.name?.capitalized ?? ""
            idText = "#\(pokemon.id ?? 0)"

            if let stringUrl = pokemon.sprites?.other?.officialArtwork?.frontDefault {
                imageUrl = URL(string: stringUrl)
            }

            if let types = pokemon.types {
                typeImages = types.compactMap { type in
                    UIImage(named: "type_\(type.type?.name ?? "")")
                }
            }

            onUpdate?()
        } catch {
            onUpdate?()
        }
    }
}
