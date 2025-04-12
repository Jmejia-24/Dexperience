//
//  EffectEntry.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

struct EffectEntry: Codable, Hashable {

    let effect: String?

    enum CodingKeys: String, CodingKey {
        case effect
    }
}
