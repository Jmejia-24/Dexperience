//
//  APICacheManager.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import Foundation

final class APICacheManager {

    static let shared = APICacheManager()

    private let cache = NSCache<NSString, NSData>()

    private init() {}
}

extension APICacheManager: APICacheManagerProtocol {

    func cachedResponse(for url: URL?) -> Data? {
        guard let url else { return nil }

        let key = url.absoluteString as NSString

        return cache.object(forKey: key) as Data?
    }

    func setCache(for url: URL?, data: Data) {
        guard let url else { return }

        let key = url.absoluteString as NSString

        cache.setObject(data as NSData, forKey: key)
    }
}
