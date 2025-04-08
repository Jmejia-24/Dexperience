//
//  APICacheManagerProtocol.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import Foundation

protocol APICacheManagerProtocol {

    func cachedResponse(for url: URL?) -> Data?
    func setCache(for url: URL?, data: Data)
}
