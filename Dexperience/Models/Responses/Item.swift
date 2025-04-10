//
//  Item.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//


struct Item: Codable {

    let id: Int?
    let name: String?
    let cost: Int?
    let sprites: Sprites

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cost
        case sprites
    }
}
