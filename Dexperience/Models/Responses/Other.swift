//
//  Other.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

nonisolated
struct Other: Codable, Hashable, Sendable {

    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}
