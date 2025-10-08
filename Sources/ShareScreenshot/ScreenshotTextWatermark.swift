//
//  ScreenshotTextWatermark.swift
//  ShareScreenshot
//
//  Created by Arne Gockeln.
//  https://arnesoftware.com

import Foundation

// Define a Text Watermark
public struct ScreenshotTextWatermark {
    let text: String
    let attributes: [NSAttributedString.Key: Any]?
    let position: WatermarkPosition
    let offset: CGFloat

    public init(text: String, at position: WatermarkPosition, attributes: [NSAttributedString.Key : Any]? = nil, offset: CGFloat = 5.0) {
        self.text = text
        self.attributes = attributes
        self.position = position
        self.offset = offset
    }
}
