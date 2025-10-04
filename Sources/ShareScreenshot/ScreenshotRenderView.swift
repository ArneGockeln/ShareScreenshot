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
    let content: () -> Content
    var completed: (UIImage) -> Void

    public init(toggle: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, completed: @escaping (UIImage) -> Void) {
        self._toggle = toggle
        self.content = content
        self.completed = completed
    }

    public var body: some View {
        ZStack {
            ScreenshotContentView(toggle: $toggle, completed: completed, content: content)
        }
    }
}
