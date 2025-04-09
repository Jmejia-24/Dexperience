//
//  APICacheManager.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import Foundation

final class APICacheManager {

    static let shared = APICacheManager()

    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    private let expirationDays: Int = 7

    private init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cachesDirectory.appendingPathComponent("APICache", isDirectory: true)

        if !fileManager.fileExists(atPath: diskCacheURL.path) {
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }
}

extension APICacheManager: APICacheManagerProtocol {

    func cachedResponse(for url: URL?) -> Data? {
        guard let url else { return nil }
        
        let key = url.absoluteString as NSString

        if let data = memoryCache.object(forKey: key) {
            return data as Data
        }

        let fileURL = diskCacheURL.appendingPathComponent(key.hashedFilename())

        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }

        memoryCache.setObject(data as NSData, forKey: key)
        return data
    }

    func setCache(for url: URL?, data: Data) {
        guard let url else { return }
        let key = url.absoluteString as NSString

        memoryCache.setObject(data as NSData, forKey: key)

        let fileURL = diskCacheURL.appendingPathComponent(key.hashedFilename())
        try? data.write(to: fileURL, options: [.atomic])
    }

    func removeExpiredFiles() {
        let expirationInterval: TimeInterval = Double(expirationDays * 24 * 60 * 60)
        let now = Date()

        guard let files = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: [.contentModificationDateKey]) else { return }

        for file in files {
            guard let modDate = try? file.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate else {
                continue
            }

            if now.timeIntervalSince(modDate) > expirationInterval {
                try? fileManager.removeItem(at: file)
            }
        }
    }
}
