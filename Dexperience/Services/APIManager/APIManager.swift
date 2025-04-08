//
//  APIManager.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import UIKit

final class APIManager {

    private let session: URLSession
    private let cacheManager: APICacheManagerProtocol

    init(cacheManager: APICacheManagerProtocol = APICacheManager.shared) {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60

        self.session = URLSession(configuration: config)
        self.cacheManager = cacheManager
    }
}

// MARK: - Private Methods

private extension APIManager {

    /// Creates a `URLRequest` from any object conforming to `HTTPBodyConvertible`.
    ///
    /// - Parameter request: A `BaseRequest` object conforming to `HTTPBodyConvertible`.
    /// - Returns: A configured `URLRequest` object, or `nil` if the URL is invalid.
    func makeRequest<T: BaseRequest & HTTPBodyConvertible>(from request: T) -> URLRequest? {
        guard let url = request.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if request.httpMethod != .get {
            urlRequest.httpBody = request.httpBody
        }

        return urlRequest
    }

    func decodeResponse<T: Codable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}

// MARK: - Execute Request

extension APIManager {

    /// Executes a network request and decodes the response into a specified type.
    ///
    /// - Parameter request: A request object conforming to `BaseRequest` and `HTTPBodyConvertible`.
    /// - Throws: An error if the network is unavailable, the request creation fails, or the response is invalid.
    /// - Returns: A decoded object of type `T` conforming to `Codable`.
    func execute<T: Codable, R: BaseRequest & HTTPBodyConvertible>(_ request: R) async throws -> T {

        guard let urlRequest = makeRequest(from: request) else {
            throw APIError.invalidURL
        }

        if let cachedData = cacheManager.cachedResponse(for: urlRequest.url) {
            return try decodeResponse(cachedData)
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.noHTTPResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
            }

            cacheManager.setCache(for: urlRequest.url, data: data)

            return try decodeResponse(data)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
