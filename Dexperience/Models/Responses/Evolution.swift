//
//  Evolution.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

nonisolated
struct Evolution: Hashable, Sendable {

    let from: String?
    let to: String?
    let minLevel: Int?
    let isVariant: Bool

    let fromSprite: String?
    let toSprite: String?
}
