![iProov: Flexible authentication for identity assurance](https://github.com/iProov/ios/raw/master/images/banner.jpg)

# iProov Biometrics iOS SDK v9.5.1

## Table of contents

- [Introduction](#introduction)
- [Repository contents](#repository-contents)
- [Upgrading from earlier versions](#upgrading-from-earlier-versions)
- [Registration](#registration)
- [Installation](#installation)
- [Get started](#get-started)
- [Options](#options)
- [Localization](#localization)
- [Handling failures & errors](#handling-failures--errors)
- [API client](#api-client)
- [Example project](#example-project)
- [Help & support](#help--support)

## Introduction

The iProov Biometrics iOS SDK enables you to integrate iProov into your iOS app. We also have an [Android Biometrics SDK](https://github.com/iProov/android), [Xamarin bindings](https://github.com/iProov/xamarin) and [Web Biometrics SDK](https://github.com/iProov/web).

### Requirements

- iOS 10.0 and above
- Xcode 13.0 and above (for Xcode 12 support, continue using iProov SDK v9.2)

The framework has been written in Swift 5.3, and we recommend use of Swift for the simplest and cleanest integration, however it is also possible to call iProov from within an Objective-C app using our [Objective-C API](https://github.com/iProov/ios/wiki/Objective-C-Support), which provides an Objective-C friendly API to invoke the Swift code.

### Dependencies

The iProov Biometrics SDK has a dependency on [Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift). This dependency will be automatically included if installing via Cocoapods.

The SDK also includes the following third-party code:

- A [forked version](https://github.com/iproovopensource/GPUImage2) of [GPUImage2](https://github.com/BradLarson/GPUImage2)
- [Expression](https://github.com/nicklockwood/Expression)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [CryptoExportImportManager](https://github.com/DigitalLeaves/CryptoExportImportManager)

These dependencies are vendored and compiled into the SDK, this requires no action and is provided for information purposes only.

### Module Stability

The iProov SDK supports module stability. The advantage of this is that the SDK no longer needs to be recompiled for every new version of the Swift compiler.

Therefore, the SDK is built with the _"Build Libraries for Distribution"_ build setting enabled, which means that its dependencies must also be built in the same fashion. This must be also be set for both Cocoapods and Carthage (see installation documentation for details).

## Repository contents

The framework package is provided via this repository, which contains the following:

* **README.md** - This document!
* **Example** - A basic sample project using iProov, written in Swift and using Cocoapods.
* **iProov.xcframework** - The iProov framework in XCFramework format. You can add this to your project manually if you aren't using a dependency manager.
* **iProov.framework** - The iProov framework as a "fat" dynamic framework for both device & simulator. (You can use this if you are unable to use the XCFramework version for whatever reason.)
* **iProovAPIClient** - Directory containing the iOS API client.
* **iProov.podspec** - Required by Cocoapods. You do not need to do anything with this file.
* **resources** - Directory containing additional development resources you may find helpful.
* **iProovTargets** - Directory containing dummy file, required for SPM.
* **carthage** - Directory containing files required for Carthage support.

## Upgrading from earlier versions

If you're already using an older version of the iProov Biometrics SDK, consult the [Upgrade Guide](https://github.com/iProov/ios/wiki/Upgrade-Guide) for detailed information about how to upgrade your app.

## Registration

You can obtain API credentials by registering on the [iProov Portal](https://portal.iproov.com/).

## Installation

Integration with your app is supported via Cocoapods, Swift Package Manager and Carthage. We recommend Cocoapods for the easiest and most flexible installation.

### Cocoapods

The SDK is distributed as an XCFramework, therefore **you are required to use Cocoapods 1.9.0 or newer**.

1. If you are not yet using Cocoapods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing Cocoapods, [click here](https://guides.cocoapods.org/using/getting-started.html#installation).)

2. Add the following to your Podfile (inside the target section):

	```ruby
	pod 'iProov'
	```
	
3. Add the following to the bottom of your Podfile:

	```ruby
	post_install do |installer|
	  installer.pods_project.targets.each do |target|
	    if ['iProov', 'Socket.IO-Client-Swift', 'Starscream'].include? target.name
	      target.build_configurations.each do |config|
	          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
	      end
	    end
	  end
	end
	```

4. Run `pod install`.

### Swift Package Manager

> **NOTE:** If your app has existing dependencies on [Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift) and/or [Starscream](https://github.com/daltoniam/Starscream), you must either remove those existing dependencies and use the iProov-supplied versions, or should avoid installing iProov via SPM and instead use one of the other installation methods.

#### Installing via Xcode

1. Select `File` → `Add Packages…` in the Xcode menu bar.

2. Search for the iProov SDK package using the following URL:

	```
	https://github.com/iProov/ios
	```
	
3. Set the _Dependency Rule_ to be _Up to Next Major Version_ and input 9.5.1 as the lower bound.
	
3. Click _Add Package_ to add the iProov SDK to your Xcode project and then click again to confirm.

#### Installing via Package.swift

If you prefer, you can add iProov via your Package.swift file as follows:

```swift
.package(
	name: "iProov",
	url: "https://github.com/iProov/ios.git",
	.upToNextMajor(from: "9.5.1")
),
```

Then add `iProov` to the `dependencies` array of any target for which you wish to use iProov.

### Carthage

> **NOTE: You are strongly advised to use Carthage v0.38.0 or above**, which has full support for pre-built XCFrameworks, however older versions of Carthage are still supported (but you must use traditional universal/"fat" frameworks instead).

1. Add the following to your Cartfile:

	```
	binary "https://raw.githubusercontent.com/iProov/ios/master/carthage/IProov.json"
	github "socketio/socket.io-client-swift" == 16.0.1
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
	
	1. When building universal ("fat") frameworks, it ensures that duplicate architectures are not lipo'd into the same framework when building on Apple Silicon Macs, in accordance with [the official Carthage workaround](https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md) (note that the document refers to Xcode 12 but it also applies to Xcode 13).

	2. It ensures that the SocketIO & Starscream frameworks are built with the `BUILD_LIBRARY_FOR_DISTRIBUTION` setting enabled.
	
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

----

### Add an `NSCameraUsageDescription`

All iOS apps which require camera access must request permission from the user, and specify this information in the Info.plist.

Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

## Get started

### Get a token

Before being able to launch iProov, you need to get a token to iProov against. There are 2 different token types:

* A **verify** token - for logging-in an existing user
* An **enrol** token - for registering a new user

iProov offers Genuine Presence Assurance™ technology and Liveness Assurance™ technology:

* [**Genuine Presence Assurance**](https://www.iproov.com/iproov-system/technology/genuine-presence-assurance) verifies that an online remote user is the right person, a real person and that they are authenticating right now, for purposes of access control and security.
* [**Liveness Assurance**](https://www.iproov.com/iproov-system/technology/liveness-assurance) verifies a remote online user is the right person and a real person for access control and security.

Please consult our [REST API documentation](https://secure.iproov.me/docs.html) for details on how to generate tokens.

> **💡 TIP:** In a production app, you should always obtain tokens securely via a server-to-server call. To save you having to setup a server for demo/PoC apps for testing, we provide Swift sample code for obtaining tokens via [iProov API v2](https://secure.iproov.me/docs.html) with our open-source [iOS API Client](#api-client). You should ensure you migrate to server-to-server calls before going into production, and don't forget to use your production API key & secret!

### Launch the SDK

Once you have obtained a token, you can simply call `IProov.launch()`:

```swift
import iProov

let streamingURL = "https://eu.rp.secure.iproov.me" // Substitute as appropriate
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
        let token: String = result.token // The token passed back will be the same as the one passed in to the original call
        let frame: UIImage? = result.frame // An optional image containing a single frame of the user, if enabled for your service provider (see important security info below)

    case let .failure(result):
        // The user was not successfully verified/enrolled, as their identity could not be verified,
        // or there was another issue with their verification/enrollment.
        // You can access the following properties:
        let token: String = result.token // The token passed back will be the same as the one passed in to the original call
        let reason: String = result.reason // A human-readable reason of why the claim failed
        let feedbackCode: String = result.feedbackCode // A code referring to the failure reason (see list below)
        let frame: UIImage? = result.frame // An optional image containing a single frame of the user, if enabled for your service provider (see important security info below)

    case .cancelled:
        // The user cancelled iProov, either by pressing the close button at the top right, or sending
        // the app to the background.

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

> **⚠️ SECURITY NOTICE:** You should never use iProov as a local authentication method. This means that:
> 
> * You cannot rely on the fact that the success result was returned to prove that the user was authenticated or enrolled successfully (it is possible the iProov process could be manipulated locally by a malicious user). You can treat the success callback as a hint to your app to update the UI, etc. but you must always independently validate the token server-side (using the `/validate` API call) before performing any authenticated user actions.
> 
> * The `frame` returned in the success & failure results should be used for UI/UX purposes only. If you require an image for upload into your system for any reason (e.g. face matching, image analysis, user profile image, etc.) you should retrieve this securely via the server-to-server [`/validate`](https://secure.iproov.me/docs.html#operation/userVerifyValidate) API call.

## Options

You can customize the iProov session by passing in an `Options` reference when launching iProov and setting any of these values:

```swift
let options = Options()

/*
	UIOptions
	Configure options relating to the user interface
*/

// Adjust various colors for the camera preview:
options.ui.filter = .shaded // Adjust the filter used for the face preview. Can be .classic, .shaded (additional detail, the default) or .vibrant (full color).
options.ui.lineColor = .white
options.ui.backgroundColor = .black

// Adjust colors for the header/footer bars and text labels:
options.ui.headerTextColor = .white // The header title text color
options.ui.promptTextColor = .white // The instructions prompt color
options.ui.headerBackgroundColor = UIColor(white: 0, alpha: 0.67)
options.ui.footerBackgroundColor = UIColor(white: 0, alpha: 0.67)

// GPA-specific options:
options.ui.genuinePresenceAssurance.autoStartDisabled = false // Disable the "auto start" countdown functionality. The user will have to tap the screen to start iProoving.
options.ui.genuinePresenceAssurance.notReadyTintColor = .orange
options.ui.genuinePresenceAssurance.readyTintColor = .green
options.ui.genuinePresenceAssurance.progressBarColor = .black
options.ui.genuinePresenceAssurance.notReadyFloatingPromptBackgroundColor = .blue // Sets the background color of the floating instructions prompt when the user has not aligned their face.
options.ui.genuinePresenceAssurance.notReadyOverlayStrokeColor = .red // Sets the oval and reticle stroke color when the user has not aligned their face.
options.ui.genuinePresenceAssurance.readyFloatingPromptBackgroundColor = .yellow // Sets the background color of the floating instructions prompt when the user has aligned their face.
options.ui.genuinePresenceAssurance.readyOverlayStrokeColor = .green // Sets the oval and reticle stroke color when the user has aligned their face.
        
// LA-specific colors:
options.ui.livenessAssurance.primaryTintColor = .blue
options.ui.livenessAssurance.secondaryTintColor = .lightGray
options.ui.livenessAssurance.overlayStrokeColor = .black // Sets the oval and reticle stroke color.
options.ui.livenessAssurance.floatingPromptBackgroundColor = .white // Set the background color of the floating instructions prompt.
        
// Customise the close button:
options.ui.closeButtonImage = UIImage(named: "close")!
options.ui.closeButtonTintColor = .white

// Customise other UI settings:
options.ui.title = "Authenticating to ACME Bank" // Specify a custom title to be shown. Defaults to nil which will hide the message entirely.
options.ui.font = "SomeFont" // You can specify your own font. This can either be a system font or a custom font in your app bundle (in which case don't forget to also add the font file to your Info.plist).
options.ui.logoImage = UIImage(named: "AcmeLogo") // A custom logo to be shown at the top-right of the iProov screen.
options.ui.presentationDelegate = MyPresentationDelegate() // See the section below entitled "Custom IProovPresentationDelegate".
options.ui.floatingPromptEnabled = true // Whether the instructions prompt should "float" over the user's face (true) or be placed in the footer (false - default).
options.ui.floatingPromptRoundedCorners = true // Whether the floating instructions prompt should have rounded corners (default is true).

// Localization settings:
options.ui.stringsBundle = Bundle(for: Foo.class) // Pass a custom bundle for string localization (see Localization Guide for further information).
options.ui.stringsTable = "Localizable-MyApp.strings" // Pass a custom strings filename (table name) for string localization.

/*
	NetworkOptions
	Configure options relating to networking & security
*/

options.network.certificates = [Bundle.main.path(forResource: "custom_cert", ofType: "der")!] // Certificates to be used for SSL pinning. Array elements should be of type String (path to certificate) or Data (the certificate itself).  Useful when using your own reverse proxy to stream to iProov. Pinning can be disabled by passing an empty array (never do this in production apps!) See more info in the FAQs. Certificates should be passed in DER-encoded X.509 certificate format, e.g. with the command: $ openssl x509 -in cert.crt -outform der -out cert.der
options.network.timeout = 10 // The network timeout in seconds.
options.network.path = "/socket.io/v2/" // The path to use when streaming, defaults to /socket.io/v2/. You should not need to change this unless directed to do so by iProov.

/*
	CaptureOptions
	Configure options relating to the capture functionality
*/

// You can specify max yaw/roll/pitch deviation of the user's face to ensure a given pose. Values are provided in normalised units.
// These options should not be set for general use. Please contact iProov for further information if you would like to use this feature.

options.capture.genuinePresenceAssurance.maxYaw = 0.03
options.capture.genuinePresenceAssurance.maxRoll = 0.03
options.capture.genuinePresenceAssurance.maxPitch = 0.03

```

### Custom `IProovPresentationDelegate`

By default, upon launching the SDK, it will get a reference to your app delegate's window's `rootViewController`, then iterate through the view controller stack to find the top-most view controller and then `present()` iProov's view controller as a modal view controller from the top-most view controller on the stack.

This may not always be the desirable behaviour; for instance, you may wish to present iProov as part of a `UINavigationController`-based flow. Therefore, it is also possible to set the `options.ui.presentationDelegate` property, which allows you to override the presentation/dismissal behaviour of the iProov view controller by conforming to the `IProovPresentationDelegate` protocol:

```swift
extension MyViewController: IProovPresentationDelegate {

    func present(iProovViewController: UIViewController) {
        // How should we present the iProov view controller?
    }

    func dismiss(iProovViewController: UIViewController) {
        // How should we dismiss the iProov view controller once it's done?
    }

}
```

> ⚠️ **IMPORTANT:** There are a couple of important rules you **must** follow when using this functionality:
> 
> 1. With great power comes great responsibility! The iProov view controller requires full coverage of the entire screen in order to work properly. Do not attempt to present your view controller to the user in such a way that it only occupies part of the screen, or is obscured by other views. Also, you must ensure that the view controller is entirely removed from the user's view once dismissed.
> 
> 2. To avoid the risk of retain cycles, `Options` only holds a **weak** reference to your presentation delegate. Ensure that your presentation delegate is retained for the lifetime of the iProov capture session, or you may result in a defective flow.

## Localization

The SDK ships with English strings only. If you wish to customise the strings in the app or localize them into a different language, see our [Localization Guide](https://github.com/iProov/ios/wiki/Localization).

## Handling failures & errors

### Failures

Failures occur when the user's identity could not be verified for some reason. A failure means that the capture was successfully received and processed by the server, which returned a result. Crucially, this differs from an error, where the capture itself failed due to a system failure.

Failures are caught via the `.failure(reason, feedbackCode)` enum case in the callback:

- `reason` - The reason that the user could not be verified/enrolled. You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time

- `feedbackCode` - An internal representation of the failure code.

The current feedback codes and reasons are as follows:

| `feedbackCode` | `reason` |
|-----------------------------------|---------------------------------------------------------------|
| `ambiguous_outcome` | Sorry, ambiguous outcome |
| `motion_too_much_movement` | Please do not move while iProoving |
| `lighting_flash_reflection_too_low` | Ambient light too strong or screen brightness too low |
| `lighting_backlit` | Strong light source detected behind you |
| `lighting_too_dark` | Your environment appears too dark |
| `lighting_face_too_bright` | Too much light detected on your face |
| `motion_too_much_mouth_movement` | Please do not talk while iProoving |

The list of feedback codes and reasons is subject to change.

### Errors

Errors occur when the capture could not be completed due to a technical problem or user action which prevents the capture from completing.

Errors are caught via the `.error(error)` enum case in the callback. The `error` parameter provides the reason the iProov process failed as an `IProovError`.

A description of these cases are as follows:

* `captureAlreadyActive` - An existing iProov capture is already in progress. Wait until the current capture completes before starting a new one.
* `networkError(String?)` - An error occurred with the video streaming process. Consult the error associated value for more information.
* `cameraPermissionDenied` - The user disallowed access to the camera when prompted. You should direct the user to re-enable camera access via Settings.
* `serverError(String?)` - A server-side error/token invalidation occurred. The associated string will contain further information about the error.
* `unexpectedError(String)` - An unexpected and unrecoverable error has occurred. These errors should be reported to iProov for further investigation.

## API client

The [iProov iOS API Client](https://github.com/iProov/ios/tree/master/iProovAPIClient) is a simple wrapper for the [iProov REST API v2](https://secure.iproov.me/docs.html) written in Swift and using [Alamofire](https://github.com/Alamofire/Alamofire) for use in demo/PoC apps.

For further details, see the [documentation](https://github.com/iProov/ios/blob/master/iProovAPIClient/README.md) in the iProovAPIClient folder.

## Example project

For a simple iProov experience that is ready to run out-of-the-box and uses the iProov API client, check out the [Example project](https://github.com/iProov/ios/tree/master/Example).

### Installation

1. Ensure that you have [Cocoapods installed](https://guides.cocoapods.org/using/getting-started.html#installation) and then run `pod install` from the Example directory to install the required dependencies.

2. Rename `Credentials.example.swift` to `Credentials.swift` and update it with your Base URL, API Key and Secret. You can obtain these credentials from the [iProov Portal](https://portal.iproov.com).

3. Open `Example.xcworkspace`.

4. You can now build and run the project. Please note that you can only launch iProov on a real device; it will not work in the simulator.

> **⚠️ SECURITY NOTICE:** The Example project uses the [iOS API Client](https://github.com/iProov/ios-api-client) to directly fetch tokens on-device and this is inherently insecure. Production implementations of iProov should always obtain tokens securely from a server-to-server call.

## Help & support

You may find your question is answered in our [FAQs](https://github.com/iProov/ios/wiki/Frequently-Asked-Questions) or one of our other [Wiki pages](https://github.com/iProov/ios/wiki).

For further help with integrating the iProov Biometrics SDK, please contact [support@iproov.com](mailto:support@iproov.com).
