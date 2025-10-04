//
//  ScreenshotContentExample.swift
//  ShareScreenshot
//
//  Created by Arne Gockeln on 04.10.25.
//

import SwiftUI
import ShareScreenshot

struct ScreenshotContentExample: View {

    @State private var toggleScreenshot: Bool = false
    @State private var shareableImage: ShareableImage?

    var body: some View {
        VStack {
            ScreenshotRenderView(toggle: $toggleScreenshot) {
                // Begin Content: This is the Content that is rendered as screenshot
                ZStack {
                    Rectangle().fill(.green.gradient)

                    VStack {
                        Text("Lorem ipsum dolor sit a met.")
                            .font(.system(size: 60))
                            .multilineTextAlignment(.center)
                            .padding(.vertical)

                        Image(systemName: "circle.grid.cross")
                            .font(.system(size: 60))
                            .bold()
                            .foregroundStyle(Color.white)
                            .rotationEffect(.degrees(27))
                    }

                }
                .ignoresSafeArea()
                // End Content.
            } completed: { image in
                // When the screenshot was taken, assign it to the shareableImage state var
                // this triggers the sheet below
                self.shareableImage = ShareableImage(image: image, title: "Sharing is caring")
            }

            // This button will trigger the screenshot
            Button(action: { self.toggleScreenshot.toggle() }) {
                Label("Share Screenshot", systemImage: "square.and.arrow.up")
                    .tint(Color.black)
                    .font(.title3)
            }
        }
        // When the shareableImage was set, the activity view sheet will open
        .sheet(item: $shareableImage, onDismiss: {}, content: { image in
            ActivityViewController(shareableImage: image)
        })
    }
}

#Preview {
    ScreenshotContentExample()
}
