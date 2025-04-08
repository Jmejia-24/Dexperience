//
//  BaseRequest.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

class BaseRequest {

    // MARK: - Nested Types

    struct Constants {

        static var baseUrl: String {
            return "https://pokeapi.co/api/v2"
        }
    }

    // MARK: - Properties

    let endpoint: Endpoint?
    let pathComponents: [String]
    let queryParameters: [URLQueryItem]
    let customURL: URL?

    // MARK: - Initializers

    /// Initializes a new instance of `BaseRequest`.
    ///
    /// - Parameters:
    ///   - endpoint: The specific API endpoint.
    ///   - pathComponents: Additional path components to append after the endpoint.
    ///   - queryParameters: Query parameters for the URL.
    init(endpoint: Endpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.customURL = nil
    }

    init(customURL: URL) {
        self.endpoint = nil
        self.pathComponents = []
        self.queryParameters = []
        self.customURL = customURL
    }

    // MARK: - Computed Properties

    /// `urlString` is a computed property that constructs and returns the full URL string,
    /// including the endpoint, path components, and query parameters.
    var urlString: String {
        if let customURL {
            return customURL.absoluteString
        }

        var string = Constants.baseUrl
        string += "/"

        if let endpoint {
            string += endpoint.rawValue
        }

        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }

        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            string += argumentString
        }

        return string
    }

    /// `url` is a computed property that constructs a `URL` object from `urlString`.
    /// If the string is invalid, it returns `nil`.
    var url: URL? {
        if let customURL {
            return customURL
        }

        return URL(string: urlString)
    }
}
