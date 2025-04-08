//
//  Request.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

final class Request: BaseRequest, HTTPBodyConvertible {

    private let bodyDictionary: [String: Any?]?
    private let encodableBody: Encodable?

    let httpMethod: HTTPMethod

    init(
        endpoint: Endpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = [],
        bodyDictionary: [String: Any?]? = nil,
        encodableBody: Encodable? = nil,
        httpMethod: HTTPMethod = .get
    ) {
        self.bodyDictionary = bodyDictionary
        self.encodableBody = encodableBody
        self.httpMethod = httpMethod

        super.init(endpoint: endpoint, pathComponents: pathComponents, queryParameters: queryParameters)
    }

    init(
        with customURL: URL,
        bodyDictionary: [String: Any?]? = nil,
        encodableBody: Encodable? = nil,
        httpMethod: HTTPMethod = .get
    ) {
        self.bodyDictionary = bodyDictionary
        self.encodableBody = encodableBody
        self.httpMethod = httpMethod

        super.init(customURL: customURL)
    }

    /// Serializes the request body to JSON.
    ///
    /// - Returns: The JSON-encoded body as `Data`, or `nil` if encoding fails.
    var httpBody: Data? {
        if let bodyDictionary {
            return try? JSONSerialization.data(withJSONObject: bodyDictionary.compactMapValues { $0 }, options: [])
        } else if let encodableBody {
            return try? JSONEncoder().encode(AnyEncodable(encodableBody))
        }

        return nil
    }
}
