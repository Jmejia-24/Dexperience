//
//  DynamicShareItem.swift
//  Dexperience
//
//  Created by Byron on 4/25/25.
//

import UIKit
import LinkPresentation

final class DynamicShareItem: NSObject, UIActivityItemSource {
    let title: String
    let url: URL
    let image: UIImage?

    init(title: String, url: URL, image: UIImage? = nil) {
        self.title = title
        self.url = url
        self.image = image
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        title
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        url
    }

    func activityViewControllerThumbnailImage(_ activityViewController: UIActivityViewController, suggestedSize size: CGSize) -> UIImage? {
        image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()

        metadata.title = title
        metadata.originalURL = url

        if let image = image {
            metadata.imageProvider = NSItemProvider(object: image)
        }

        return metadata
    }
}
