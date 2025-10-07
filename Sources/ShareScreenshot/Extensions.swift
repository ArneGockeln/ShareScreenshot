//
//  ScreenshotViewExtension.swift
//  Elated
//
//  Created by Arne Gockeln on 04.10.25.
//

import UIKit
import SwiftUI

extension UIView {
    // Take Screenshot from drawHierachy with TextWatermark rendered
    func takeScreenshot(withTextWatermark watermark: ScreenshotTextWatermark?, afterScreenUpdates: Bool) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            // Take View Screenshot
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)

            guard let textWatermark = watermark,
                      !textWatermark.text.isEmpty else {
                return
            }

            // Text Attributes
            let textAttributes: [NSAttributedString.Key: Any] = textWatermark.attributes ?? [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.white.withAlphaComponent(0.7),
                .shadow: {
                    let shadow = NSShadow()
                    shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
                    shadow.shadowOffset = CGSize(width: 1, height: 1)
                    shadow.shadowBlurRadius = 3
                    return shadow
                }()
            ]

            // Text Size & Position
            let textSize = textWatermark.text.size(withAttributes: textAttributes)
            let offset = textWatermark.offset
            let origin = pointForPosition(
                textWatermark.position,
                markSize: textSize,
                in: bounds
            )

            // Draw Text
            textWatermark.text.draw(
                at: CGPoint(
                    x: origin.x - offset,
                    y: origin.y - offset
                ),
                withAttributes: textAttributes
            )
        }
    }

    // Take Screenshot from drawHierachy with ImageWatermark rendered
    func takeScreenshot(withUIImageWatermark watermark: ScreenshotImageWatermark?, afterScreenUpdates: Bool) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            // Take View Screenshot
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)

            guard let imageWatermark = watermark else {
                return
            }

            // Calculate aspect ratio for watermark image
            let watermarkScale = imageWatermark.scale
            let wWidth = bounds.width * watermarkScale
            let aspect = imageWatermark.image.size.height / imageWatermark.image.size.width
            let wHeight = wWidth * aspect
            let markSize = CGSize(width: wWidth, height: wHeight)
            let origin = pointForPosition(
                imageWatermark.position,
                markSize: markSize,
                in: bounds
            )
            let wRect = CGRect(
                origin: CGPoint(
                    x: origin.x - imageWatermark.offset,
                    y: origin.y - imageWatermark.offset
                ),
                size: markSize
            )

            // Draw Watermark Image on Image
            imageWatermark.image.withRenderingMode(.alwaysOriginal).draw(
                in: wRect,
                blendMode: .normal,
                alpha: alpha
            )
        }
    }

    private func pointForPosition(_ position: WatermarkPosition, markSize size: CGSize, in rect: CGRect) -> CGPoint {
        switch position {
            case .topLeading:
                return .zero
            case .topCenter:
                return CGPoint(x: rect.width / 2, y: 0)
            case .topTrailing:
                return CGPoint(x: rect.width / 2 - size.width, y: 0)
            case .leading:
                return CGPoint(x: 0, y: rect.height / 2 - size.height / 2)
            case .center:
                return CGPoint(x: rect.width / 2 - size.width / 2, y: rect.height / 2 - size.height / 2)
            case .trailing:
                return CGPoint(x: rect.width - size.width, y: rect.height / 2 - size.height / 2)
            case .bottomLeading:
                return CGPoint(x: 0, y: rect.height - size.height)
            case .bottomCenter:
                return CGPoint(x: rect.width / 2 - size.width / 2, y: rect.height - size.height)
            case .bottomTrailing:
                return CGPoint(x: rect.width - size.width, y: rect.height - size.height)
        }
    }
}

extension View {
    // Get HostingController for Self
    private func uiHostingController(frame: CGRect, afterScreenUpdates: Bool) -> UIHostingController<Self> {
        let hosting = UIHostingController(rootView: self)
        hosting.overrideUserInterfaceStyle = UIApplication.shared.currentUIWindow()?.overrideUserInterfaceStyle ?? .unspecified
        hosting.view.frame = frame
        hosting.ignoreSafeArea()
        return hosting
    }

    // Take Screenshot with optional Text Watermark
    func takeScreenshot(frame: CGRect, watermark: ScreenshotTextWatermark?, afterScreenUpdates: Bool) -> UIImage {
        let hosting = uiHostingController(frame: frame, afterScreenUpdates: afterScreenUpdates)
        return hosting.view.takeScreenshot(withTextWatermark: watermark, afterScreenUpdates: afterScreenUpdates)
    }

    // Take Screenshot with optional Image Watermark
    func takeScreenshot(frame: CGRect, watermark: ScreenshotImageWatermark?, afterScreenUpdates: Bool) -> UIImage {
        let hosting = uiHostingController(frame: frame, afterScreenUpdates: afterScreenUpdates)
        return hosting.view.takeScreenshot(withUIImageWatermark: watermark, afterScreenUpdates: afterScreenUpdates)
    }
}

extension UIHostingController {
    func ignoreSafeArea() {
        if #available(iOS 16.4, *) {
            self.safeAreaRegions = []
        } else {
            let currentSafeAreaInset = UIApplication.shared.currentUIWindow()?.safeAreaInsets ?? .zero
            self.additionalSafeAreaInsets = currentSafeAreaInset.reversed()
        }
    }
}

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }

        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}

extension UIEdgeInsets {
    func reversed() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}

extension UIImage {
    // Convert UIImage to Data
    func toData() -> Data? {
        return self.pngData() ?? self.jpegData(compressionQuality: 1.0)
    }

    // Calculate image's file size
    func fileSize() -> String {
        guard let imageData = self.toData() else { return "Unknown size" }
        let size = Double(imageData.count) // in bytes
        if size < 1024 {
            return String(format: "%.2f bytes", size)
        } else if size < 1024 * 1024 {
            return String(format: "%.2f KB", size/1024.0)
        } else {
            return String(format: "%.2f MB", size/(1024.0*1024.0))
        }
    }

    #if DEBUG
    // Determine image's file type
    func fileType() -> String {
        guard let data = self.toData(), data.count > 8 else { return "unknown" }

        var header = [UInt8](repeating: 0, count: 8)
        data.copyBytes(to: &header, count: 8)

        switch header {
        case [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]: // PNG: 89 50 4E 47 0D 0A 1A 0A
            return "png"
        case [0xFF, 0xD8, 0xFF]: // JPEG: FF D8 FF
            return "jpg"
        default:
            return "unknown"
        }
    }
    #endif
}
