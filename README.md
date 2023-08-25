![iProov: Flexible authentication for identity assurance](https://github.com/iProov/ios/raw/master/images/banner.jpg)

# iProov Biometrics iOS SDK v10.3.1

## Introduction

The iProov Biometrics iOS SDK enables you to integrate iProov into your iOS app. We also have an [Android SDK](https://github.com/iProov/android), [Xamarin SDK](https://github.com/iProov/xamarin), [Flutter SDK](https://github.com/iProov/flutter), [React Native SDK](https://github.com/iProov/react-native) and [Web SDK](https://github.com/iProov/web).

### Requirements

- iOS 11.0 and above
- Xcode 13.0 and above

The framework has been written in Swift 5.5, and we recommend the use of Swift for the simplest and cleanest integration, however, it is also possible to call iProov from within an Objective-C app using our [Objective-C API](https://github.com/iProov/ios/wiki/Objective-C-Support), which provides an Objective-C friendly API to invoke the Swift code.

### Dependencies

The iProov Biometrics SDK has a dependency on [Starscream](https://github.com/daltoniam/Starscream). This dependency will be automatically included if installed via any of the dependency managers listed below.

The SDK also includes the following third-party code:

- A [forked version](https://github.com/iproovopensource/GPUImage2) of [GPUImage2](https://github.com/BradLarson/GPUImage2)
- [Expression](https://github.com/nicklockwood/Expression)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [CryptoExportImportManager](https://github.com/DigitalLeaves/CryptoExportImportManager)
- [SwiftProtobuf](https://github.com/apple/swift-protobuf)

These dependencies are vendored and compiled into the SDK, this requires no action and is provided for information and licensing purposes only.

### Module Stability

The iProov SDK supports module stability. The advantage of this is that the SDK does not need to be recompiled for every new version of the Swift compiler.

Therefore, the SDK is built with the _"Build Libraries for Distribution"_ build setting enabled, which means that its dependencies must also be built with this enabled. Therefore, you must ensure that this is set for both CocoaPods and Carthage (see installation documentation for details).

## Repository Contents

The framework package is provided via this repository, which contains the following:

* **README.md** - This document!
* **Example** - A basic sample project using iProov, written in Swift and using CocoaPods.
* **iProov.xcframework** - The iProov framework in XCFramework format. You can add this to your project manually if you aren't using a dependency manager.
* **iProov.framework** - The iProov framework as a "fat" dynamic framework for both device & simulator. (You can use this if you are unable to use the XCFramework version for whatever reason.)
* **iProovAPIClient.podspec & iProovAPIClient** - Files relating to the iOS API client.
* **iProov.podspec** - Required by CocoaPods. You do not need to do anything with this file.
* **resources** - Directory containing additional development resources you may find helpful.
* **iProovTargets** - Directory containing dummy file, required for SPM.
* **carthage** - Directory containing files required for Carthage support.

## Upgrading from Earlier Versions

If you're already using an older version of the iProov Biometrics SDK, consult the [Upgrade Guide](https://github.com/iProov/ios/wiki/Upgrading-to-SDK-v10.x) for detailed information about how to upgrade your app.

## Registration

You can obtain API credentials by registering on the [iProov Portal](https://portal.iproov.com/).

## Installation

Integration with your app is supported via CocoaPods, Swift Package Manager, and Carthage. You can also install the SDK manually in Xcode without the use of any dependency manager (this is not recommended). We recommend CocoaPods for the easiest and most flexible installation.

### CocoaPods

> **Note**: The SDK is distributed as an XCFramework, therefore **you are required to use CocoaPods 1.9.0 or newer**.

1. If you are not yet using CocoaPods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing CocoaPods, [click here](https://guides.cocoapods.org/using/getting-started.html#installation).)

2. Add the following to your Podfile (inside the target section):

	```ruby
	pod 'iProov'
	```
	
3. Add the following to the bottom of your Podfile:

	```ruby
	post_install do |installer|
	  installer.pods_project.targets.each do |target|
	    if ['iProov', 'Starscream'].include? target.name
	      target.build_configurations.each do |config|
	          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
	      end
	    end
	  end
	end
	```

4. Run `pod install`.

### Swift Package Manager

> **Note**: If your app has an existing dependency on [Starscream](https://github.com/daltoniam/Starscream), you must either remove that existing dependency and use the iProov-supplied versions, or should avoid installing iProov via SPM and instead use one of the other installation methods.

#### Installing via Xcode

1. Select `File` → `Add Packages…` in the Xcode menu bar.

2. Search for the iProov SDK package using the following URL:

	```
	https://github.com/iProov/ios
	```
	
3. Set the _Dependency Rule_ to be _Up to Next Major Version_ and input 10.3.1 as the lower bound.
	
3. Click _Add Package_ to add the iProov SDK to your Xcode project and then click again to confirm.

#### Installing via Package.swift

If you prefer, you can add iProov via your Package.swift file as follows:

```swift
.package(
	name: "iProov",
	url: "https://github.com/iProov/ios.git",
	.upToNextMajor(from: "10.3.1")
),
```

Then add `iProov` to the `dependencies` array of any target for which you wish to use iProov.

### Carthage

> **Note**: **You are strongly advised to use Carthage v0.38.0 or above**, which has full support for pre-built XCFrameworks, however older versions of Carthage are still supported (but you must use traditional universal/"fat" frameworks instead).

1. Add the following to your Cartfile:

	```
	binary "https://raw.githubusercontent.com/iProov/ios/master/carthage/IProov.json"
	github "daltoniam/Starscream" >= 4.0.0
	```
	
2. Create the following script named _carthage.sh_ in your root Carthage directory:

	```sh
	# carthage.sh
	# Usage example: ./carthage.sh build --platform iOS
	
	set -euo pipefail
	 
	xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
	trap 'rm -f "$xcconfig"' INT TERM HUP EXIT
	
	if [[ "$@" != *'--use-xcframeworks'* ]]; then
		# See https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md for further details
	
		CURRENT_XCODE_VERSION="$(xcodebuild -version | grep "Xcode" | cut -d' ' -f2 | cut -d'.' -f1)00"
		CURRENT_XCODE_BUILD=$(xcodebuild -version | grep "Build version" | cut -d' ' -f3)
	
		echo "EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_${CURRENT_XCODE_VERSION}__BUILD_${CURRENT_XCODE_BUILD} = arm64 arm64e armv7 armv7s armv6 armv8" >> $xcconfig
		echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_'${CURRENT_XCODE_VERSION}' = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_$(XCODE_VERSION_MAJOR)__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
		echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig
	fi
	
	echo 'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' >> $xcconfig
	
	export XCODE_XCCONFIG_FILE="$xcconfig"
	carthage "$@"
	```
	
	This script contains two important workarounds:
	
	1. When building universal ("fat") frameworks, it ensures that duplicate architectures are not lipo'd into the same framework when building on Apple Silicon Macs, in accordance with [the official Carthage workaround](https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md) (note that the document refers to Xcode 12 but it also applies to Xcode 13 and 14).

	2. It ensures that the Starscream framework is built with the `BUILD_LIBRARY_FOR_DISTRIBUTION` setting enabled.
	
3. Make the script executable:
	
	```sh
	chmod +x carthage.sh
	```
	
4. You must now use `./carthage.sh` instead of `carthage` to build the dependencies.

	**Carthage 0.38.0 and above (use XCFrameworks):**
	
	```sh
	./carthage.sh update --use-xcframeworks --platform ios
	```
	
	**Carthage 0.37.0 and below (use universal frameworks):**
	
	```sh
	./carthage.sh update --platform ios
	```

5. Add the built .framework/.xcframework files from the _Carthage/Build_ folder to your project in the usual way.

	**Carthage 0.37.0 and below only:**
	
	You should follow the additional instructions [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to remove simulator architectures from your universal binaries prior to running your app/submitting to the App Store.

### Manual Installation

![Xcode manual installation steps](https://github.com/iProov/ios/raw/master/images/xcode_manual_install.png)

1. Select your project in Xcode.

2. Select your app target.

3. Select the **General** tab and then scroll down to **Frameworks, Libraries, and Embedded Content**.

4. Add the following files from the [release assets](https://github.com/iProov/ios/releases/tag/10.3.1):

	- `iProov.xcframework`
	- `Starscream.xcframework`

	> **Note**: Ensure you add the .xcframework files, rather than the .framework files.

5. Under the **Embed** column, ensure **Embed & Sign** is set for all frameworks.

----

### Add an `NSCameraUsageDescription`

All iOS apps which require camera access must request permission from the user, and specify this information in the Info.plist.

Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

## Get Started

### Get a Token

Before being able to launch iProov, you need to get a token to iProov against. There are 2 different token types:

* A **verify** token - for logging-in an existing user
* An **enrol** token - for registering a new user

iProov offers Genuine Presence Assurance™ technology and Liveness Assurance™ technology:

* [**Genuine Presence Assurance**](https://www.iproov.com/iproov-system/technology/genuine-presence-assurance) verifies that an online remote user is the right person, a real person and that they are authenticating right now, for purposes of access control and security.
* [**Liveness Assurance**](https://www.iproov.com/iproov-system/technology/liveness-assurance) verifies a remote online user is the right person and a real person for access control and security.

Please consult our [REST API documentation](https://secure.iproov.me/docs.html) for details on how to generate tokens.

> **Warning**: In a production app, you should always obtain tokens securely via a server-to-server call. To save you from having to setup a server for demo/PoC apps for testing, we provide Swift sample code for obtaining tokens via [iProov API v2](https://secure.iproov.me/docs.html) with our open-source [iOS API Client](#api-client). You should ensure you migrate to server-to-server calls before going into production, and don't forget to use your production API key & secret!

### Launch the SDK

Once you have obtained a token, you can simply call `IProov.launch()`:

```swift
import iProov

let streamingURL = "wss://eu.rp.secure.iproov.me/ws" // Substitute as appropriate
let token = "{{ your token here }}"

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

    case let .success(result):
        // The user was successfully verified/enrolled and the token has been validated.
        // You can access the following properties:
        let frame: UIImage? = result.frame // An optional image containing a single frame of the user, if enabled for your service provider (see important security info below)

    case let .failure(result):
        // The user was not successfully verified/enrolled, as their identity could not be verified,
        // or there was another issue with their verification/enrollment.
        // You can access the following properties:
        let reason: FailureReason = result.reason // A reason of why the claim failed
        let failureCode: String = reason.failureCode // A code referring to the failure reason (see list below)
        let localizedDescription: String = result.localizedDescription // A human-readable suggestion about what to do to get to a successful claim
        let frame: UIImage? = result.frame // An optional image containing a single frame of the user, if enabled for your service provider (see important security info below)

    case .cancelled(canceller):
        // Either:
        //
        // (a) The user cancelled iProov by pressing the close button, or sending the
        // app to the background (canceller will be .user), or
        //
        // (b) You cancelled iProov by calling cancel() on the SDK (canceller will be .app) - see cancellation below.

    case let .error(error):
        // The user was not successfully verified/enrolled due to an error (e.g. lost internet connection)
        // along with an `iProovError` with more information about the error (NSError in Objective-C).
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
> * The `frame` returned in the success & failure results should be used for UI/UX purposes only. If you require an image for upload into your system for any reason (e.g. face matching, image analysis, user profile image, etc.) you should retrieve this securely via the server-to-server [`/validate`](https://secure.iproov.me/docs.html#operation/userVerifyValidate) API call.


### Cancelling the SDK

Under normal circumstances, the user will be in control of the completion of the iProov scan, i.e. they will either complete the scan, or use the close button to cancel. In some cases, you (the integrator) may wish to cancel the iProov scan programmatically, for example in response to a timeout or change of conditions in your app.

To cancel the iProov SDK, you first need to hold a reference to the iProov session (returned from `IProov.launch()`) and you can then call `cancel()` on it.

```swift
let session = IProov.launch(...)

DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Example - cancel the session after 10 sec
    session.cancel() // Will return true if the session was successfully cancelled
}
```

## Options

You can customize the iProov session by passing in an `Options` reference when launching iProov and setting any of these values:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `filter` | Adjust the filter used for the face preview. [See below for further detail](#filter-options). | `LineDrawingFilter()` |
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
| `surroundColor` | Color applied the area outside the oval. | `.black.withAlphaComponent(0.4)` |
| `headerBackgroundColor ` | The color of the header bar. | `nil` |
| `certificates` | Certificates to be used for SSL pinning. [See below for further details](#certificates). | iProov Server Certificates |
| `timeout` | Network timeout to be applied to the WebSocket connection. | `10` (seconds) |

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

> **Note**: `NaturalFilter` is available for Liveness Assurance claims only. Attempts to use `NaturalFilter` for Genuine Presence Assurance claims will result in an error.
> 
> If `disableExteriorEffects` is set to true, `filter` can not be set to `NaturalFilter.Style.blur`. This combination of options will result in an error.

### Certificate Pinning

By default, the iProov SDK pins to the iProov server certificates, which are used by `*.rp.secure.iproov.me`.

If you are using your own reverse-proxy, you will need to update the pinning configuration to pin to your own certificate(s) instead.

Certificates should be passed as an array of `Data`, which are DER-encoded X.509 certificates. You can load a DER-encoded certificate from your app bundle as follows:

```swift
options.certificates = [try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "certificate", ofType: "der")!))]
```

To convert from a `.crt` file to `.der`, use the following command:

```sh
$ openssl x509 -in cert.crt -outform der -out cert.der
```

When multiple certificates are passed, as long as the server matches **any** of the certificates, the connection will be allowed. Pinning is performed against the **public key** of the certificate.

You can also disable certificate pinning entirely, by passing an empty array:

```swift
options.certificates = []
```

> **Warning**: Never disable certificate pinning in production apps!

### Genuine Presence Assurance Options

GPA-specific options can be set under `Options.genuinePresenceAssurance`:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `notReadyOvalStrokeColor` | Color for oval stroke when in a GPA "not ready" state. | `.white` |
| `readyOvalStrokeColor`| Color for oval stroke when in the GPA "ready" state. | #01AC41 |
| `maxYaw` (deprecated) | Maximum acceptable yaw of user's face\*. | `-1` (disabled) |
| `maxRoll` (deprecated) | Maximum acceptable roll of user's face\*. | `-1` (disabled) |
| `maxPitch` (deprecated) | Maximum acceptable pitch of user's face\*. | `-1` (disabled) |

\* These options are used to implement pose control, which is deprecated and will be removed in a future SDK version. Values are provided in normalized units (0 to 1), where -1 means disabled. These options should not be set for general use; please contact iProov for further information if you would like to use this feature.

### Liveness Assurance Options

LA-specific options can be set under `Options.livenessAssurance`:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `ovalStrokeColor` | Color for oval stroke during LA scan. | `.white` |
| `completedOvalStrokeColor`| Color for oval stroke after LA scan completes. | #01AC41 |

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

> **Warning**: There are a couple of important rules you **must** follow when using this functionality:
> 
> 1. With great power comes great responsibility! The iProov view controller requires full coverage of the entire screen in order to work properly. Do not attempt to present your view controller to the user in such a way that it only occupies part of the screen, or is obscured by other views. You must also ensure that the view controller is entirely removed from the user's view once dismissed.
> 
> 2. To avoid the risk of retain cycles, `Options` only holds a `weak` reference to your presentation delegate. Ensure that your presentation delegate is retained for the lifetime of the iProov capture session, or you may result in a defective flow.

> **Note**: The default UI options defined above have been verified to comply with the [WCAG 2.1 AA accessibility standard](https://www.iproov.com/blog/biometric-authentication-liveness-accessibility-inclusivity-wcag-regulations). Changing these values could result in non-compliance with the guidelines.

## Localization

The SDK ships with support for the following languages:

- English - `en`
- Dutch - `de`
- French - `fr`
- German - `de`
- Italian - `it`
- Portuguese - `pt`
- Portuguese (Brazil) - `pt-BR`
- Spanish - `es`
- Spanish (Columbia) - `es-CO`
- Welsh - `cy-GB`

You can customize the strings from your app or localize them into a different language. For further details, see our [Localization Guide](https://github.com/iProov/ios/wiki/Localization).

## Handling Failures & Errors

### Failures

Failures occur when the user's identity could not be verified. A failure means that the capture was successfully received and processed by the server, which returned a result. Crucially, this differs from an error, where the capture itself failed due to a system failure.

Failures are caught via the `.failure(reason)` enum case in the callback. The `reason` is an enum with the reason that the user could not be verified/enrolled, which has the following properties:

- `feedbackCode` - A string representation of the feedback code.

- `localizedDescription` - You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time.

#### Genuine Presence Assurance

The available failure reasons for Genuine Presence Assurance claims are as follows:

| Enum value | `localizedDescription` (English) |
|---|---|
| `unknown` | Try again |
| `tooMuchMovement` | Keep still |
| `tooBright` | Move somewhere darker |
| `tooDark` | Move somewhere brighter |
| `misalignedFace` | Keep your face in the oval |
| `eyesClosed` | Keep your eyes open |
| `faceTooFar` | Move your face closer to the screen |
| `faceTooClose` | Move your face farther from the screen |
| `sunglasses` | Remove sunglasses |
| `obscuredFace` | Remove any face coverings |
| `userTimeout` | Try again |
| `notSupported` | Device is not supported |

#### Liveness Assurance

The available failure reasons for Liveness Assurance claims are as follows:

| Enum value | `localizedDescription` (English) |
|---|---|
| `unknown` | Try again |
| `userTimeout` | Try again |
| `notSupported` | Device is not supported |

### Errors

Errors occur when the capture could not be completed due to a technical problem or user action which prevents the capture from completing.

Errors are caught via the `.error(error)` enum case in the callback. The `error` parameter provides the reason the iProov process failed as an `IProovError`.

| Enum value | Description |
|---|---|
| `captureAlreadyActive` | An existing iProov capture is already in progress. Wait until the current capture completes before starting a new one. |
| `cameraPermissionDenied ` | The user disallowed access to the camera when prompted. You should direct the user to re-enable camera access via Settings. |
| `networkError(String?)` | An error occurred with the video streaming process. The associated string (if available) will contain further information about the error. |
| `serverError(String?)` | A server-side error/token invalidation occurred. The associated string (if available) will contain further information about the error. |
| `unexpectedError(String)` | An unexpected and unrecoverable error has occurred. The associated string will contain further information about the error. These errors should be reported to iProov for further investigation. |

## API Client

The [iProov iOS API Client](https://github.com/iProov/ios/tree/master/iProovAPIClient) is a simple wrapper for the [iProov REST API v2](https://secure.iproov.me/docs.html) written in Swift and using [Alamofire](https://github.com/Alamofire/Alamofire) for use in demo/PoC apps.

For further details, see the [documentation](https://github.com/iProov/ios/blob/master/iProovAPIClient/README.md) in the iProovAPIClient folder.

## Example Project

For a simple iProov experience that is ready to run out-of-the-box and uses the iProov API client, check out the [Example project](https://github.com/iProov/ios/tree/master/Example).

### Installation

1. Ensure that you have [CocoaPods installed](https://guides.cocoapods.org/using/getting-started.html#installation) and then run `pod install` from the Example directory to install the required dependencies.

2. Rename `Credentials.example.swift` to `Credentials.swift` and update it with your Base URL, API Key and Secret. You can obtain these credentials from the [iProov Portal](https://portal.iproov.com).

3. Open `Example.xcworkspace`.

4. You can now build and run the project. Please note that you can only launch iProov on a real device; it will not work in the simulator.

> **Warning**: The Example project uses the [iOS API Client](https://github.com/iProov/ios-api-client) to directly fetch tokens on-device and this is inherently insecure. Production implementations of iProov should always obtain tokens securely from a server-to-server call.

## Help & Support

You may find your question answered in our [FAQs](https://github.com/iProov/ios/wiki/Frequently-Asked-Questions) or one of our other [Wiki pages](https://github.com/iProov/ios/wiki).

Consult the [Documentation Center](https://docs.iproov.com/) for the detailed [implementation guide](https://docs.iproov.com/docs/Content/ImplementationGuide/biometric-sdk/ios/sdk-ios-intro.htm), [glossary](https://docs.iproov.com/docs/Content/Glossary/iproov-glossary.htm), and API reference.

For further help with integrating the iProov Biometrics SDK, please contact [support@iproov.com](mailto:support@iproov.com).
