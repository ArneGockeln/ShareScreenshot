//
//  ScreenshotImageWatermark.swift
//  ShareScreenshot
//
//  Created by Arne Gockeln.
//  https://arnesoftware.com

import SwiftUI

// Define a Image Watermark
public struct ScreenshotImageWatermark {
    let image: UIImage
    let position: WatermarkPosition
    let scale: CGFloat
    let offset: CGFloat

    public init(image: UIImage, position: WatermarkPosition, scale: CGFloat = 0.15, offset: CGFloat = 5.0) {
        self.image = image
        self.position = position
        self.scale = scale
        self.offset = offset
    }
}
