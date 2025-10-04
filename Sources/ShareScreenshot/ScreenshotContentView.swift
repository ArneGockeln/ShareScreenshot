//
//  ScreenshotContentView.swift
//  Elated
//
//  Created by Arne Gockeln on 04.10.25.
//
//  Inspired by https://github.com/RickeyBoy/ScreenshotableView

import SwiftUI

struct ScreenshotContentView<Content: View>: View {
    @Binding var toggle: Bool
    var completed: (UIImage) -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        func internalView(proxy: GeometryProxy) -> some View {
            if self.toggle {
                let frame = proxy.frame(in: .local)
                DispatchQueue.main.async {
                    toggle = false
                    // Use content with
                    let screenshot = self.content().takeScreenshot(frame: frame, afterScreenUpdates: true)
                    self.completed(screenshot)
                }
            }

            return Color.clear
        }

        // Display content with inView style
        return content().background(GeometryReader(content: internalView(proxy:)))
    }
}
