//
//  ItemsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import Foundation

protocol ItemsRepository {

    func fetchItemList(from url: URL?) async throws -> PokemonListResponse
    func fetchItem(url: URL) async throws -> Item
}
