# ShareScreenshot
A SwiftUI Package to `take` and `share` screenshots of SwiftUI Views. This works in portrait and landscape mode.

## 💻 Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate `ShareScreenshot` into your Xcode project using Xcode 26, specify it in `File > Swift Packages > Add Package Dependency...`:

```ogdl
https://https://github.com/ArneGockeln/ShareScreenshot.git, :branch="main"
```

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

## Requirements
- iOS v18.6 is the minimum requirement.
- Swift 6
- A SwiftUI Project

## 📃 License
`ShareScreenshot` is available under the MIT license. See the [LICENSE](https://github.com/ArneGockeln/ShareScreenshot/blob/main/LICENSE) file for more info.

## 📦 Projects

The following projects have integrated ShareScreenshot:

- [Elated | Countdown Widgets](https://apps.apple.com/de/app/elated-urlaubs-countdown-timer/id6740820297)
- [PushUp Battle ](https://apps.apple.com/us/app/push-up-battle-counter/id6752408363)
