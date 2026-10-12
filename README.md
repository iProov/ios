![iProov: Flexible authentication for identity assurance](https://github.com/iProov/ios/raw/master/images/banner.jpg)

# iProov Face SDK v14.0.0

## Introduction

This guide describes how to integrate iProov biometric assurance technologies into your iOS app, or SDK.

iProov offers two powerful authentication solutions:

* **Dynamic Liveness™** technology (our **Genuine Presence Assurance™** solution) verifies that an online remote user is the right person, a real person, and that they are authenticating right now, for purposes of access control and security.
* **Express Liveness™** technology (our **Liveness Assurance™** solution) verifies that a remote online user is the right person and a real person for access control and security.

### Software Download & Installation

The SDK can be downloaded and installed directly into your iOS application, or incorporated into your own SDK.

Our downloadable software components implementing **Dynamic Liveness™** and **Express Liveness™** technologies integrate seamlessly with your existing user journeys.

### Web Services & API Access

In addition to our downloadable software components, iProov provides identity authentication services through our secure API and web-based administration portal.
These services enable organizations to implement **Dynamic Liveness™** and **Express Liveness™** verification capabilities across their digital platforms.

Find out more about how to use iProov in your user journeys in the [Implementation Guide](https://docs.iproov.com/implementation_A-Z/architecutre_overview).

iProov also supports [Android](https://github.com/iproov/android), [Flutter](https://github.com/iproov/flutter), [MAUI](https://github.com/iProov/dotnet-maui), [React Native](https://github.com/iproov/react-native), and [Web](https://github.com/iProov/web).

### Requirements

- iOS 16.0 and above
- Xcode 26.0 and above

The framework has been written in Swift 5.10, and we recommend the use of Swift for the simplest and cleanest integration, however, it is also possible to call iProov from within an Objective-C app using our [Objective-C API](https://github.com/iProov/ios/wiki/Objective-C-Support), which provides an Objective-C friendly API to invoke the Swift code.

### Dependencies

The SDK includes the following third-party code:

- [Expression](https://github.com/nicklockwood/Expression)
- [CryptoExportImportManager](https://github.com/DigitalLeaves/CryptoExportImportManager)
- [SwiftProtobuf](https://github.com/apple/swift-protobuf)
- [TrustKit](https://github.com/datatheorem/TrustKit)

These dependencies are vendored and compiled into the SDK, this requires no action and is provided for information and licensing purposes only.

### Module Stability

The SDK supports module stability. The advantage of this is that the SDK does not need to be recompiled for every new version of the Swift compiler.

## Repository Contents

The framework package is provided via this repository, which contains the following:

* **README.md** - This document!
* **Example** - A basic sample project using iProov, written in Swift and using Swift Package Manager.
* **iProov.xcframework** - The iProov framework in XCFramework format. You can add this to your project manually if you aren't using a dependency manager.
* **iProov.podspec** - Used by our React Native wrapper to install the SDK with CocoaPods. You do not need to do anything with this file.
* **resources** - Directory containing additional development resources you may find helpful.
* **iProovTargets** - Directory containing dummy file, required for SPM.

## Upgrading from Earlier Versions

If you're already using an older version of the SDK, consult the [Upgrade Guide](https://github.com/iProov/ios/wiki/Upgrade-Guide) for detailed information about how to upgrade your app.

## Registration

You can obtain API credentials by registering on the [iProov Portal](https://portal.iproov.com/).

## Installation

We recommend using Swift Package Manager for integrating our SDK with your app or SDK.

> **Warning**: CocoaPods trunk will become read-only in December 2026.
> CocoaPods support has not been removed yet, purely to support our React Native wrapper while its SPM support is still experimental.  

You can still install the SDK manually in Xcode, but we don't recommend this method, please migrate to SPM.

### Swift Package Manager

#### Installing via Xcode

1. Select `File` → `Add Packages…` in the Xcode menu bar.

2. Search for the SDK package using the following URL:

	```
	https://github.com/iProov/ios-spm
	```
	
3. Set the _Dependency Rule_ to be _Up to Next Major Version_ and input 14.0.0 as the lower bound.

4. Click _Add Package_ to add the SDK to your Xcode project and then click again to confirm.

#### Installing via Package.swift

If you prefer, you can add iProov via your Package.swift file as follows:

```swift
.package(
	name: "iProov",
	url: "https://github.com/iProov/ios-spm.git",
	.upToNextMajor(from: "14.0.0")
),
```

Then add `iProov` to the `dependencies` array of any target for which you wish to use iProov.

As Swift Package Manager downloads the full repository for a package, installing this main SDK package [iProov/ios](https://github.com/iProov/ios) can take a long time (over 2 minutes in some environments). The smaller repository [iProov/ios-spm](https://github.com/iProov/ios-spm) significantly reduces the SDK installation time by providing only a reference to the precompiled xcframework, which is published with [the latest SDK release](https://github.com/iProov/ios/releases).

### Manual Installation
![Xcode manual installation steps](https://github.com/iProov/ios/raw/master/images/xcode_manual_install.png)

1. Select your project in Xcode.

2. Select your app target.

3. Select the **General** tab and then scroll down to **Frameworks, Libraries, and Embedded Content**.

4. Add `iProov.xcframework` from the [release assets](https://github.com/iProov/ios/releases/tag/14.0.0).

5. Under the **Embed** column, ensure **Embed & Sign** is set.

----

### Add an `NSCameraUsageDescription`

All iOS apps which require camera access must request permission from the user, and specify this information in the Info.plist.

Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

## Get Started

iProov uses Genuine Presence™ technology to assure the identity of a user remotely; ensuring the user is the right person, a real person, and they are authenticating right now. Using our patented Flashmark™ solution, iProov ensures accurate online identity verification.

### Get a Token

Before being able to launch iProov, you need to get a token to iProov against. There are 2 different token types:

* A **verify** token - for logging-in an existing user
* An **enrol** token - for registering a new user

iProov offers Genuine Presence Assurance™ technology (also known as "Dynamic Liveness") and Liveness Assurance™ technology (also known as "Express Liveness"):

* [**Genuine Presence Assurance**](https://www.iproov.com/iproov-system/technology/genuine-presence-assurance) verifies that an online remote user is the right person, a real person and that they are authenticating right now, for purposes of access control and security.
* [**Liveness Assurance**](https://www.iproov.com/iproov-system/technology/liveness-assurance) verifies a remote online user is the right person and a real person for access control and security.

Please consult our [REST API documentation](https://secure.iproov.me/docs.html) for details on how to generate tokens.

> **Warning**: In a production app, you should always obtain tokens securely via a server-to-server call. To save you from having to setup a server for demo/PoC apps for testing, we provide Swift sample code for obtaining tokens via [iProov API v2](https://secure.iproov.me/docs.html) with our open-source [iOS API Client](https://github.com/iProov/ios-api-client). You should ensure you migrate to server-to-server calls before going into production, and don't forget to use your production API key & secret!

### Launch the SDK

Once you have obtained a token, you can simply call `IProov.launch()`:

```swift
import iProov

let token = "{{ your token here }}"
let streamingURLString = "wss://eu.rp.secure.iproov.me/ws" // Substitute as appropriate

guard let streamingURL = URL(string: streamingURLString) else {
    // handle your URL error
    return
}

IProov.launch(streamingURL: streamingURL, token: token) { status in

    switch status {
    case .connecting:
        // The SDK is connecting to the server. You should provide an indeterminate progress indicator
        // to let the user know that the connection is taking place.

    case .connected:
        // The SDK has connected, and the iProov user interface will now be displayed. You should hide
        // any progress indication at this point.

    case let .processing(progress, message):
        // The scan has completed, and the SDK will update your app with the progress of streaming
        // to the server and authenticating the user.
        // This will be called multiple times as the progress updates.

    case .success:
        // The user was successfully verified/enrolled and the token has been validated.

    case let .failure(reasons):
        // The user was not successfully verified/enrolled, as their identity could not be verified,
        // or there was another issue with their verification/enrollment.
        // `reasons` is a [FailureReason] describing why the claim failed:
        let feedbackCodes: String = reasons.map(\.feedbackCode).joined(separator: ",") // Codes referring to the failure reasons (see list below)
        let localizedDescriptions: String = reasons.map(\.localizedDescription).joined(separator: " ") // Human-readable suggestions about what to do to get to a successful claim

    case let .canceled(canceler):
        // Either:
        //
        // (a) The user canceled iProov by pressing the close button, or sending the
        // app to the background (canceler will be .user), or
        //
        // (b) You canceled iProov by calling cancel() on the SDK (canceler will be .integration) - see cancelation below.

    case let .error(error):
        // The user was not successfully verified/enrolled due to an error (e.g. lost internet connection)
        // along with an `IProovError` with more information about the error (NSError in Objective-C).
        // It will be called once, or never.

    @unknown default:
        // Reserved for future usage.
        break
    }
}
```

> **Warning**: **You should never use iProov as a local authentication method.** This means that:
> 
> * You cannot rely on the fact a successful result was returned to prove that the user was authenticated or enrolled successfully (it is possible the iProov process could be manipulated locally by a malicious user). You can treat the success callback as a hint to your app to update the UI, etc. but you must always independently validate the token server-side (using the `/validate` API call) before performing any authenticated user actions.
> 
> * The SDK does not return a captured image. If you require an image for upload into your system for any reason (e.g. face matching, image analysis, user profile image, etc.) you should retrieve this securely via the server-to-server [`/validate`](https://secure.iproov.me/docs.html#operation/userVerifyValidate) API call.


### Canceling the SDK

Under normal circumstances, the user will be in control of the completion of the iProov scan, i.e. they will either complete the scan, or use the close button to cancel. In some cases, you (the integrator) may wish to cancel the iProov scan programmatically, for example in response to a timeout or change of conditions in your app.

To cancel the SDK, you first need to hold a reference to the iProov session (returned from `IProov.launch()`) and you can then call `cancel()` on it.

```swift
let session = IProov.launch(...)

DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Example - cancel the session after 10 sec
    session.cancel() // Will return true if the session was successfully canceled
}
```

## Options

You can customize the iProov session by passing in an `Options` reference when launching iProov and setting any of these values:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `filter` | Adjust the filter used for the face preview. [See below for further detail](#filter-options). | `NaturalFilter()` |
| `stringsBundle`| App bundle from which strings should be retrieved.| `nil` |
| `stringsTable` | App table from which strings should be retrieved. | `nil` |
| `titleTextColor` | Text color for the title. | `.white` |
| `closeButtonTintColor` | Tint color applied to the close button. | `.white` |
| `closeButtonImage` | Image to be used for the close button. | ![Default close button](https://github.com/iProov/ios/raw/master/images/default_close_button.png) |
| `title`  | Title text to be displayed at the top of the screen. | `nil` |
| `font`  | Name of the font to be used for the title & prompt. | `"HelveticaNeue-Medium"` |
| `logoImage`  | Logo to be placed next to the title. | `nil` |
| `promptTextColor`  | Color for prompt text. | `.white` |
| `promptBackgroundColor` | Color for background of prompt. | `.black.withAlphaComponent(0.8)` |
| `promptRoundedCorners` | Whether the prompt has rounded (`true`) or straight (`false`) corners. | `true` |
| `disableExteriorEffects` | Whether the blur and vignette effect outside the oval should be disabled. | `false` |
| `presentationDelegate` | Custom logic for presenting and dismissing the iProov UI. [See below for further details](#custom-iproovpresentationdelegate). | `DefaultPresentationDelegate()` |
| `surroundColor` | Color applied to the area outside the oval. | `.black.withAlphaComponent(0.4)` |
| `headerBackgroundColor` | The color of the header bar. | `nil` |
| `certificates` | Certificates to be passed as a string (the certificate's Subject Public Key Info as SHA-256 hash). [See below for further details](#certificate-pinning). | `[]` |
| `timeout` | Network timeout to be applied to the WebSocket connection. | `10` (seconds) |
| `viewDelegate` | Optional delegate to receive UI state updates. [See below for further details](#optional-iproovviewdelegate). | `nil` |

### Filter Options

The SDK supports two different camera filters:

#### `LineDrawingFilter`

`LineDrawingFilter` is iProov's traditional "canny" filter, which is available in 3 styles: `.shaded` (default), `.classic` and `.vibrant`.

The `foregroundColor` and `backgroundColor` can also be customized.

Example:

```swift
options.filter = Options.LineDrawingFilter(style: .vibrant,
                                           foregroundColor: UIColor.black,
                                           backgroundColor: UIColor.white)
```

#### `NaturalFilter`

`NaturalFilter` provides a more direct visualization of the user's face and is available in 2 styles: `.clear` (default) and `.blur`.

Example:

```swift
options.filter = Options.NaturalFilter(style: .clear)
```

> **Note**: If `disableExteriorEffects` is set to true, `filter` can not be set to `NaturalFilter.Style.blur`. This combination of options will result in an error.

### Certificate Pinning

If you are using your own reverse-proxy, you will need to use this option to pin to your own certificates.

Certificates should be passed as an array of `String`, where the `String` is the base64-encoded SHA-256 hash of a certificate's Subject Public Key Info. You can load certificates as follows:

```swift
options.certificates = [
	"O8qZKEXWWkMPISIpvB7DUow++JzIW2g+k9z3U/l5V94=",
	"Sc7wL4FfOw8ued5w3JOSzu5MzB471PfqdyN4hnMYbX4="
]
```

To get Subject Public Key Info from a `.crt` file, use the following command:

```sh
$ openssl x509  -in cert.crt -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

To get Subject Public Key Info from a `.der` file, use the following command:

```sh
$ openssl x509 -inform der -in cert.der -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

When multiple certificates are passed, as long as the server matches **any** of the certificates, the connection will be allowed. Pinning is performed against the **public key** of the certificate.

### Genuine Presence Assurance Options

GPA-specific options can be set under `Options.genuinePresenceAssurance`:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `notReadyOvalStrokeColor` | Color for oval stroke when in a GPA "not ready" state. | `.white` |
| `readyOvalStrokeColor`| Color for oval stroke when in the GPA "ready" state. | `#01AC41` |
| `controlXPosition` | Whether to control x position of the face through showing prompts when using GPA.<br/>When any [accessibility option](#accessibility-options) is on, this is treated as enabled regardless of the value set here. | `false` |
| `controlYPosition` | Whether to control y position of the face through showing prompts when using GPA.<br/>When any [accessibility option](#accessibility-options) is on, this is treated as enabled regardless of the value set here. | `false` |
| `scanningPrompts` | Show a prompt 'Scanning' during GPA scan.<br/>Show a prompt 'Scan Completed' after GPA scan completes. | `false` |

### Accessibility Options

Accessibility options provide additional guidance for users with low vision. They can be set under `Options.genuinePresenceAssurance.accessibility`, apply to Genuine Presence Assurance only, and are all disabled by default:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `isColorEnabled` | Sweeps the `surroundColor` from orange through yellow to green as a gradient, as the user gets closer to being correctly positioned.<br/>Any colour configured for `surroundColor` is not used while this is enabled. | `false` |
| `isSoundEnabled` | Plays a click that repeats faster and grows louder as the user gets closer to being correctly positioned, then a held tone during the scan itself.<br/>The click is suppressed while VoiceOver is running, since the spoken prompts already carry the guidance, but the held tone still plays. | `false` |
| `isVibrationEnabled` | Vibrates in pulses that come faster and grow stronger as the user gets closer to being correctly positioned, then a continuous vibration during the scan itself.<br/>Unlike the sound this is not silenced while VoiceOver is running, because it is what carries proximity for a screen reader user. | `false` |

```swift
options.genuinePresenceAssurance.accessibility.isColorEnabled = true
options.genuinePresenceAssurance.accessibility.isSoundEnabled = true
options.genuinePresenceAssurance.accessibility.isVibrationEnabled = true
```

Enabling any of the three makes alignment stricter. The guidance follows how far the face is from being centred as well as how far it is from the right size, so `controlXPosition` and `controlYPosition` are treated as enabled for the capture regardless of how they are set. The values you set are not modified, but the user is asked to centre their face on both axes and gets prompts to move left, right, up or down, spoken by VoiceOver when it is running. Without this the guidance would be steering them toward a position the scan does not require.

The instruction prompt also moves. Normally it sits partway down the screen, over the oval; with any of the three enabled it is raised higher, to sit at the top of the oval so the user can see their face more clearly. This applies to Genuine Presence Assurance only, so a Liveness claim keeps the instruction where it has always been even with the options set.

With `isColorEnabled` on, the close button is also tinted dark, so it stays legible against the colours the surround sweeps through, where the standard white button all but disappears. This overrides `closeButtonTintColor`, and happens only if you have left `headerBackgroundColor` at its default. Setting a header colour means you have taken over the top of the screen, so your own tint is used unchanged.

While `isSoundEnabled` is on, the SDK takes the shared `AVAudioSession` with the `.playback` category for the capture, and releases it once the scan completes. Audio playing in other apps pauses while the capture runs, then resumes. Audio your own app is playing carries on and mixes with the SDK's sounds, since both share your process's audio session. Consider pausing it, as it competes with guidance the user may be relying on.

Nothing is audible if the device volume is turned all the way down, as an app cannot raise it on the user's behalf.

Vibration needs supported hardware. iPad has none, so the option has no effect there. The user's own device settings can also silence it, in part or in full, and the SDK cannot detect or override that.

### Liveness Assurance Options

LA-specific options can be set under `Options.livenessAssurance`:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `ovalStrokeColor` | Color for oval stroke during LA scan. | `.white` |
| `completedOvalStrokeColor`| Color for oval stroke after LA scan completes. | `#01AC41` |

### Custom `IProovPresentationDelegate`

By default, upon launching the SDK, it will get a reference to your app delegate's window's `rootViewController`, then iterate through the view controller stack to find the top-most view controller and then `present()` iProov's view controller as a modal view controller from the top-most view controller on the stack.

This may not always be the desirable behavior; for instance, you may wish to present iProov as part of a `UINavigationController`-based flow. Therefore, it is also possible to set the `options.presentationDelegate` property, which allows you to override the presentation/dismissal behavior of the iProov view controller by conforming to the `IProovPresentationDelegate` protocol:

```swift
extension MyViewController: IProovPresentationDelegate {

    func present(iProovViewController: UIViewController, completion: (() -> Void)?) {
        // How should we present the iProov view controller?
    }

    func dismiss(iProovViewController: UIViewController, completion: (() -> Void)?) {
        // How should we dismiss the iProov view controller once it's done?
    }

}
```

> **Warning**: There are a few important rules you **must** follow when using this functionality:
>
> 1. With great power comes great responsibility! The iProov view controller requires full coverage of the entire screen in order to work properly. Do not attempt to present your view controller to the user in such a way that it only occupies part of the screen, or is obscured by other views. You must also ensure that the view controller is entirely removed from the user's view once dismissed.
>
> 2. **On iPad**, the iProov view controller must be presented fullscreen (using `.fullScreen` or `.overFullScreen` `modalPresentationStyle`, or `.fullScreenCover` in SwiftUI). The SDK pauses the capture and displays an overlay prompting the user to return to fullscreen if it is presented using a non-fullscreen style (e.g. `.pageSheet`, `.formSheet`, or SwiftUI `.sheet`), if the app is in Split View or Slide Over, or if it is not the active window. It also pauses and asks the user to rotate the device if it is not in portrait orientation.
>
> 3. To avoid the risk of retain cycles, `Options` only holds a `weak` reference to your presentation delegate. Ensure that your presentation delegate is retained for the lifetime of the iProov capture session, or you may result in a defective flow.

> **Note**: The default UI options defined above have been verified to comply with the [WCAG 2.1 AA accessibility standard](https://www.iproov.com/blog/biometric-authentication-liveness-accessibility-inclusivity-wcag-regulations). Changing these values could result in non-compliance with the guidelines.

### Optional `IProovViewDelegate`

If you want to receive UI state updates from the SDK, you can set an object of a type conforming to `IProovViewDelegate` protocol to `options.viewDelegate`.

Example:

```swift
extension MyViewController: IProovViewDelegate {
    func willPresentIProovView() {
    	// Called before the iProov user interface is presented.
    }

    func didPresentIProovView() {
    	// Called when the iProov user interface is presented.
    }

    func didDismissIProovView() {
    	// Called when the iProov user interface is dismissed.
    }
}

let myViewController = MyViewController()
options.viewDelegate = myViewController
```

## Localization

The SDK ships with support for the following languages:

- English - `en`
- Dutch - `nl`
- French - `fr`
- German - `de`
- Italian - `it`
- Portuguese - `pt`
- Portuguese (Brazil) - `pt-BR`
- Spanish - `es`
- Spanish (Colombia) - `es-CO`
- Welsh - `cy-GB`

You can customize the strings from your app or localize them into a different language. For further details, see our [Localization Guide](https://github.com/iProov/ios/wiki/Localization).

## Handling Failures & Errors

### Failures

A **failure** occurs when iProov successfully processes a claim but the user's identity cannot be verified.
Crucially, this differs from an error, where the capture itself failed due to a system failure.

Failures are caught via the `.failure(reasons:)` enum case in the callback. It provides up to three `reasons` why the user could not be verified/enrolled, where each `reason` has the following properties:
- `feedbackCode` - A string representation of the feedback code.
- `localizedDescription` - You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time.

The available failure reasons are as follows:

| Enum value        | `localizedDescription` (English)                                          |
|-------------------|---------------------------------------------------------------------------|
| `systemError`     | System error.                                                             |
| `lightingIssues`  | Make sure your face is well lit and free from glare.                      |
| `faceNotFound`    | Align your face in the oval and then try to keep still.                   |
| `timeout`         | System timeout.                                                           |
| `eyewear`         | Remove your eyewear.                                                      |
| `deviceIssue`     | Try a different device.                                                   |
| `rejected`        | Transaction could not be completed.                                       |
| `backgroundIssue` | Move to a different location with a neutral background.                   |
| `motionIssue`     | Try a different device.                                                   |
| `deviceRestart`   | Please restart your device and try again.                                 |
| `framesBlurry`    | Align your face in the oval and then try to keep still. Please try again. |
| `userNotFound`    | Transaction could not be completed.                                       |
| `processingFault` | Please try again.                                                         |

The legacy codes below may still be returned in some scenarios (for example, older SDKs, or features not yet enabled for your service provider):

| Enum value        | `localizedDescription` (English)                                                            | GPA | LA |
|-------------------|---------------------------------------------------------------------------------------------|-----|----|
| `unknown`         | Try again                                                                                   | ✅  | ❌ |
| `tooMuchMovement` | Keep still                                                                                  | ✅  | ❌ |
| `tooBright`       | Move somewhere darker                                                                       | ✅  | ❌ |
| `tooDark`         | Move somewhere brighter                                                                     | ✅  | ❌ |
| `misalignedFace`  | Keep your face in the oval                                                                  | ✅  | ❌ |
| `faceTooFar`      | Move your face closer to the screen                                                         | ✅  | ❌ |
| `faceTooClose`    | Move your face farther from the screen                                                      | ✅  | ❌ |
| `sunglasses`      | Remove sunglasses                                                                           | ✅  | ❌ |
| `obscuredFace`    | Make sure your whole face is visible and remove any accessories that might cover your face. | ✅  | ✅ |
| `eyesClosed`      | Make sure your eyes are open.                                                               | ✅  | ✅ |
| `multipleFaces`   | Ensure only one person is visible.                                                          | ✅  | ✅ |

Key: ✅ = will be returned, ❌ = will not be returned

These are not an indication of tests being performed but only whether reasons of failure are reported.

### Errors

Errors occur when the capture could not be completed due to a technical problem or user action which prevents the capture from completing.

Errors are caught via the `.error(error)` enum case in the callback. The `error` parameter provides the reason the iProov process failed as an `IProovError`.

| Enum value | Description |
|---|---|
| `captureAlreadyActive` | An existing iProov capture is already in progress. Wait until the current capture completes before starting a new one. |
| `cameraPermissionDenied` | The user disallowed access to the camera when prompted. You should direct the user to re-enable camera access via Settings. |
| `consentRequired` | The user has not granted consent. For iProov internal use only. You can safely ignore. |
| `networkError(String?)` | An error occurred with the video streaming process. The associated string (if available) will contain further information about the error. |
| `serverError(String?)` | A server-side error/token invalidation occurred. The associated string (if available) will contain further information about the error. |
| `unexpectedError(String)` | An unexpected and unrecoverable error has occurred. The associated string will contain further information about the error. These errors should be reported to iProov for further investigation. |
| `userTimeout` | The user has taken too long to complete the claim. |
| `notSupported` | The device is not supported. |
| `unsupportedDevice(String?)` | The device is not supported. Do not retry. |
| `unsupportedOSVersion(String?)` | The operating system version is not supported. Do not retry. |
| `unsupportedSDKVersion(String?)` | The SDK version is not supported. Do not retry. |

## API Client

The [iProov iOS API Client](https://github.com/iProov/ios-api-client) is a simple wrapper for the [iProov REST API v2](https://secure.iproov.me/docs.html) written in Swift and using [Alamofire](https://github.com/Alamofire/Alamofire) for use in demo/PoC apps. For further details, see the [installation documentation](https://github.com/iProov/ios-api-client#installation).

## Example Project

For a simple iProov experience that is ready to run out-of-the-box and uses the iProov API client, check out the [Example project](https://github.com/iProov/ios/tree/master/Example).

### Installation

1. Rename `Credentials.example.swift` to `Credentials.swift` and update it with your Base URL, API Key and Secret. You can obtain these credentials from the [iProov Portal](https://portal.iproov.com).

2. Open `Example.xcodeproj`. Xcode resolves the SDK from this repository and the remaining dependencies from their package repositories.

3. You can now build and run the project. Please note that you can only launch iProov on a real device; it will not work in the simulator.

> **Warning**: The Example project uses the [iOS API Client](https://github.com/iProov/ios-api-client) to directly fetch tokens on-device and this is inherently insecure. Production implementations of iProov should always obtain tokens securely from a server-to-server call.

## Help & Support

You may find your question answered in our [FAQs](https://github.com/iProov/ios/wiki/Frequently-Asked-Questions) or one of our other [Wiki pages](https://github.com/iProov/ios/wiki).

Consult the [Documentation Center](https://docs.iproov.com/) for the detailed implementation guide, glossary, and API reference.

For further help with integrating the SDK, please contact [support@iproov.com](mailto:support@iproov.com).
