//
//  Language.swift
//  Dexperience
//
//  Created by Byron on 4/13/25.
//

enum EnumLanguage: String, Codable, Hashable {

    case en
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        self = EnumLanguage(rawValue: value) ?? .unknown
    }
}

struct Language: Codable, Hashable {

    let name: EnumLanguage?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
