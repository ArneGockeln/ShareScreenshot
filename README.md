# ShareScreenshot
A SwiftUI Package to `take` and `share` screenshots of SwiftUI Views. This works in portrait and landscape mode.

## 💻 Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate `ShareScreenshot` into your Xcode project using Xcode 26, specify it in `File > Swift Packages > Add Package Dependency...`:

```ogdl
https://https://github.com/ArneGockeln/ShareScreenshot.git, :branch="main"
```

## 📋 Features

- Render a UIImage of the surrounded view hierachy
- Trigger rendering by state property
- Callback with the rendered image
- Optional: Add a text watermark with text attributes
- Optional: Add a UIImage watermark

## 🌄 Usage

You will find a complete example in the `Example` folder.

Import the library and add two @State vars to the view, where you want to render a screenshot.

```swift
import ShareScreenshot

// First: this will toggle the renderer
@State private var toggleScreenshot: Bool = false
// Second: this will hold the shareable image with title
@State private var shareableImage: ShareableImage?
```

Surround your view to render with ScreenshotRenderView 

```swift
ScreenshotRenderView(toggle: $toggleScreenshot) {
    // Begin Content: This is the Content that is rendered as screenshot
    Text("Render me.")
    // End Content.
} completed: { image in
    // When the screenshot was taken, assign it to the shareableImage state var
    // this triggers the activity sheet below
    self.shareableImage = ShareableImage(image: image, title: "Sharing is caring")
}
// When the shareableImage was set, the activity sheet will open
.sheet(item: $shareableImage, onDismiss: {}, content: { image in
    ActivityViewController(shareableImage: image)
})
```

Add a button to trigger the screenshot renderer and activity sheet

```swift
// This button will trigger the screenshot
Button(action: { self.toggleScreenshot.toggle() }) {
    Label("Share Screenshot", systemImage: "square.and.arrow.up")
        .tint(Color.black)
        .font(.title3)
    }
}
```

That's it.

## 🐳 Watermarks

Add a Text or Image watermark to the rendered screenshot. 

Both options require to create a configuration struct. Set the `position` enum to place the watermark in one of the 9 standard locations (topLeading, topCenter, topTrailing, leading, center, trailing, bottomLeading, bottomCenter, bottomTrailing).

The `offset` property sets additional space between the watermark and the screenshot bounds.

### Text Watermark

Create a `ScreenshotTextWatermark` configuration. The `attributes` property lets you customize the text with NSAttributedString.Keys.

```swift
let textWatermark = ScreenshotTextWatermark(
    text: "Created with ShareScreenshot.",
    at: .bottomTrailing,
    attributes: [
        .foregroundColor: UIColor(item.foregroundColor),
        .font: UIFont.boldSystemFont(ofSize: 24)
    ],
    offset: 20
)
```

Then render the screenshot as described above:

```swift
ScreenshotRenderView(toggle: $toggleScreenshot, watermark: textWatermark) { ... }
```

### UIImage Watermark

Create a `ScreenshotImageWatermark` configuration. The `scale` property allows you to adjust the size of the watermark image so that it is proportional to the aspect ratio of the screenshot.

```swift
let imageWatermark = ScreenshotImageWatermark(
    image: UIImage(named: "AppIcon")!,
    position: .bottomCenter,
    scale: 0.5,
    offset: 10.0
)
```

Then render the screenshot as described above:

```swift
ScreenshotRenderView(toggle: $toggleScreenshot, watermark: imageWatermark) { ... }
```

## 📝 Requirements
- iOS v18.6 is the minimum requirement.
- Swift 6
- A SwiftUI Project

## 📃 License
`ShareScreenshot` is available under the MIT license. See the [LICENSE](https://github.com/ArneGockeln/ShareScreenshot/blob/main/LICENSE) file for more info.

## 📦 Projects

The following projects have integrated ShareScreenshot:

- [Elated | Countdown Widgets](https://apps.apple.com/de/app/elated-urlaubs-countdown-timer/id6740820297)
- [PushUp Battle ](https://apps.apple.com/us/app/push-up-battle-counter/id6752408363)

Want to be listed here? Send a PR.