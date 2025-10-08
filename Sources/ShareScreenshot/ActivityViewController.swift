//
//  ActivityViewController.swift
//  ShareScreenshot
//
//  Created by Arne Gockeln.
//  https://arnesoftware.com

import SwiftUI

public struct ActivityViewController: UIViewControllerRepresentable {
    let shareableImage: ShareableImage

    public init(shareableImage: ShareableImage) {
        self.shareableImage = shareableImage
    }

    public func makeUIViewController(context: Context) -> some UIActivityViewController {
        UIActivityViewController(activityItems: [shareableImage], applicationActivities: nil)
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
