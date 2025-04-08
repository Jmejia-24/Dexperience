//
//  ImageCacheManager.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class ImageCacheManager {

    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func save(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
