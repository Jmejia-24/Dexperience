//
//  Other.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

struct Other: Codable, Hashable {

    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}
