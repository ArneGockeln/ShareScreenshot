//
//  ScreenshotRenderView.swift
//  Elated
//
//  Created by Arne Gockeln on 04.10.25.
//

import SwiftUI

/// Any ViewBuilder content that is placed in `content` will be rendered as screenshot image.
public struct ScreenshotRenderView<Content: View>: View {
    @Binding var toggle: Bool
    var watermark: ScreenshotImageWatermark? = nil
    var watermarkText: ScreenshotTextWatermark? = nil
    let content: () -> Content
    var completed: (UIImage) -> Void

    public init(toggle: Binding<Bool>, watermark: ScreenshotImageWatermark?, @ViewBuilder content: @escaping () -> Content, completed: @escaping (UIImage) -> Void) {
        self._toggle = toggle
        self.content = content
        self.completed = completed
        self.watermark = watermark
        self.watermarkText = nil
    }

    public init(toggle: Binding<Bool>, watermark: ScreenshotTextWatermark?, @ViewBuilder content: @escaping () -> Content, completed: @escaping (UIImage) -> Void) {
        self._toggle = toggle
        self.content = content
        self.completed = completed
        self.watermarkText = watermark
        self.watermark = nil
    }

    public var body: some View {
        ZStack {
            if let watermark {
                ScreenshotContentView(toggle: $toggle, watermark: watermark, completed: completed, content: content)
            } else if let watermarkText {
                ScreenshotContentView(toggle: $toggle, watermarkText: watermarkText, completed: completed, content: content)
            } else {
                ScreenshotContentView(toggle: $toggle, completed: completed, content: content)
            }
        }
    }
}
