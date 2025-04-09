//
//  TypeResponse.swift
//  Dexperience
//
//  Created by Byron on 4/8/25.
//

struct TypeResponse: Codable {

    let damageRelations: DamageRelations

    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
    }
}
