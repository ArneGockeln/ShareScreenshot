//
//  ShareableImage.swift
//  ShareScreenshot
//
//  Created by Arne Gockeln.
//  https://arnesoftware.com

import SwiftUI
import LinkPresentation

public final class ShareableImage: NSObject, UIActivityItemSource, Identifiable {
    public let id = UUID()
    private let image: UIImage
    private let title: String

    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title

        super.init()
    }

    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }

    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }

    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metaData = LPLinkMetadata()
        metaData.iconProvider = NSItemProvider(object: self.image)
        metaData.title = self.title
        let size = image.fileSize()
        let subtitleString = "Screenshot File · \(size)"
        metaData.originalURL = URL(fileURLWithPath: subtitleString)
        return metaData
    }
}
