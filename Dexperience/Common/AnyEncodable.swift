//
//  AnyEncodable.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

struct AnyEncodable: Encodable {

    private let _encode: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self._encode = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
