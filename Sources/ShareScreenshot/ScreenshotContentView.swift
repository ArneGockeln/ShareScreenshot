//
//  ScreenshotContentView.swift
//  ShareScreenshot
//
//  Created by Arne Gockeln.
//  https://arnesoftware.com

import SwiftUI

struct ScreenshotContentView<Content: View>: View {
    @Binding var toggle: Bool
    var watermark: ScreenshotImageWatermark?
    var watermarkText: ScreenshotTextWatermark?
    var completed: (UIImage) -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        //  Inspired by https://github.com/RickeyBoy/ScreenshotableView
        func internalView(proxy: GeometryProxy) -> some View {
            if self.toggle {
                let frame = proxy.frame(in: .local)
                DispatchQueue.main.async {
                    toggle = false
                    // Use content with
                    var screenshot: UIImage
                    if let watermarkText {
                        screenshot = self.content().takeScreenshot(frame: frame, watermark: watermarkText, afterScreenUpdates: true)
                    } else {
                        screenshot = self.content().takeScreenshot(frame: frame, watermark: watermark, afterScreenUpdates: true)
                    }
                    self.completed(screenshot)
                }
            }

            return Color.clear
        }

        // Display content with inView style
        return content().background(GeometryReader(content: internalView(proxy:)))
    }
}
