//
//  GameVersion.swift
//  Dexperience
//
//  Created by Byron on 4/13/25.
//

enum EnumVersion: String, Codable, Hashable {

    case alphaSapphire = "alpha-sapphire"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        self = EnumVersion(rawValue: value) ?? .unknown
    }
}

struct GameVersion: Codable, Hashable {

    let name: EnumVersion?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
