//
//  APIError.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

enum APIError: Error {

    case invalidURL
    case noHTTPResponse
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
}
