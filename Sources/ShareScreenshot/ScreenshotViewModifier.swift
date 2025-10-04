//
//  ScreenshotViewModifier.swift
//  Elated
//
//  Created by Arne Gockeln on 04.10.25.
//
//
//import SwiftUI
//
///// Present a toolbar share button to toggle the rendering of the view content
//public struct ScreenshotWithToolbarButtonViewModifier: ViewModifier {
//    let title: String
//
//    @State private var toggle: Bool = false
//    @State private var screenshotImage: ShareableImage?
//
//    public func body(content: Content) -> some View {
//        ScreenshotRenderView(toggle: $toggle) {
//            content
//                .toolbar {
//                    ToolbarItem {
//                        Button(action: {
//                            self.toggle.toggle()
//                        }) {
//                            Label("Share", systemImage: "square.and.arrow.up")
//                        }
//                    }
//                }
//        } completed: { image in
//            self.screenshotImage = ShareableImage(image: image, title: self.title)
//        }
//        .sheet(item: $screenshotImage, onDismiss: {}, content: { image in
//            ActivityViewController(imageWrapper: image)
//        })
//    }
//}
//
///// Render the view content with external toggle
//public struct ScreenshotWithButtonViewModifier: ViewModifier {
//    @Binding var toggle: Bool
//    let title: String
//
//    @State private var screenshotImage: ShareableImage?
//
//    public func body(content: Content) -> some View {
//        ScreenshotRenderView(toggle: $toggle) {
//            content
//        } completed: { image in
//            self.screenshotImage = ShareableImage(image: image, title: self.title)
//        }
//        .sheet(item: $screenshotImage, onDismiss: {}, content: { image in
//            ActivityViewController(imageWrapper: image)
//        })
//    }
//}
//
//public extension View {
//    /// Present a toolbar share button and render the view content on touch
//    /// - Parameters:
//    ///     - title: The shared image title.
//    func shareScreenshotWithToolbarButton(title: String) -> some View {
//        modifier(ScreenshotWithToolbarButtonViewModifier(title: title))
//    }
//
//    /// Render the view content when toggle changes
//    /// - Parameters:
//    ///     - toggle: When changed: start rendering.
//    ///     - title: The shared image title.
//    func shareScreenshotWithButton(toggle: Binding<Bool>, title: String) -> some View {
//        modifier(ScreenshotWithButtonViewModifier(toggle: toggle, title: title))
//    }
//}
