//
//  EffectEntry.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

struct EffectEntry: Codable, Hashable {

    let effect: String?
    let shortEffect: String?
    let language: Language?

    enum CodingKeys: String, CodingKey {
        case effect
        case language
        case shortEffect = "short_effect"
    }
}
