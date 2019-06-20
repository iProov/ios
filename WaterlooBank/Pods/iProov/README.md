# iProov iOS SDK v7.0.0-beta2

## 🤳 Introduction

The iProov iOS SDK allows you to integrate iProov into your iOS app. We also have an [Android SDK](https://github.com/iproov/android) and [HTML5 client](https://github.com/iProov/html5).

> **💠 PRE-RELEASE SOFTWARE:** This version is currently in beta and not all features of the SDK are enabled or fully operations.

The iProov iOS SDK is a binary iOS dynamic framework. It is supported on devices running iOS 9.0 and above, on both iPhones and iPads, using Xcode 10.2.1 (see note below regarding Xcode version compatibility).

The framework has been written in Swift, and we recommend use of Swift for the simplest and cleanest integration, however it is also possible to call iProov from within an Objective-C app using our Objective-C wrapper, which provides an Objective-C friendly API to invoke the Swift code.

## 📖 Contents

The framework package is provided via this repository, which contains the following:

* **README.md** -- this document
* **WaterlooBank** -- a folder containing an Xcode sample project of iProov for the fictitious _Waterloo Bank_ written in Swift.
* **WaterlooBankObjC** -- a folder containing an Xcode sample project for _Waterloo Bank_ written in Objective-C.
* **iProov.framework & iProov.podspec** -- these are the files which will be pulled in automatically by Cocoapods. You do not need to do anything with these files.

## 💠 Pre-release software

Please note that iOS SDK v7.0.0 is currently beta (pre-release) software for pre-release evaluation/testing purposes only, **and is not intended to be used in production**. Do not put this SDK into a production app without checking with iProov first.

#### Known issues

- The SDK can only be installed via Cocoapods `:git` parameter, and is not available on the trunk repo. v7 will soon be available on the trunk repo.
- The new evolutionary adaptive lighting model is still undergoing training. You may experience failures to iProov in particularly bright environments (e.g. outdoors).
- We do not currently have Waterloo Bank sample code in Objective-C.

Look out for the 💠 symbol in the documentation for additional/missing information in relating to pre-release software.

If you find any other issues, please [contact support](mailto:support@iproov.com).

## ⚠️ Important notice regarding Xcode compatibility

Please note that iProov is distributed as a compiled binary framework. Due to [current Swift limitations](https://forums.swift.org/t/plan-for-module-stability/14551), this means that the version of Xcode (and the version of Swift) that was used to compile the iProov framework must exactly match the version of Xcode used to compile your app.

The version of Xcode used to compile v7.0.0 of the SDK is Xcode 10.2.1 (Swift 5.0.1).

Therefore, this is the only supported version of Xcode for iProov. If you are using an older version of Xcode and cannot upgrade for whatever reason, you will need to use an older version of the SDK ([contact iProov](mailto:support@iproov.com) for further details).

> **NOTE:** With the addition of [module stability in Swift 5.1](https://swift.org/blog/5-1-release-process/) we look forward to providing an updated version of the SDK with the release of iOS 13 later this year, which will support multiple Swift compiler versions.

## ⬆️ Upgrading from v6.x or earlier

Welcome to the next generation of the iProov SDK! v7 is a substantial overhaul to the SDK and added many new features, and as a result **SDK v7 is a major update and includes breaking changes!**

Please consult the [Upgrade Guide](https://github.com/iProov/ios/wiki/Upgrade-Guide) for detailed information about how to upgrade your app, and look out for the ⬆️ symbol in this README.

## ✍️ Registration

You can obtain API credentials by registering on the [iProov Partner Portal](https://www.iproov.net).

## 📲 Installation

Integration with your app is supported via both Cocoapods and Carthage. We recommend Cocoapods for the easiest installation.

### Cocoapods

1. If you are not yet using Cocoapods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing Cocoapods, [click here](https://cocoapods.org/).)

2. Add the following to your **Podfile** (inside the target section):

	```ruby
	pod 'iProov', :git => 'https://github.com/iProov/ios.git', :branch => 'nextgen'
	```
> **💠 PRE-RELEASE SOFTWARE:** You will be able to move the `git:` and `:branch` parameters once the final version of the SDK is released.

3. Run `pod install`.

4. Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

### Carthage

Cocoapods is recommend for the easiest integration, however we also support Carthage. 
Full instructions installing and setting up Carthage [are available here](https://github.com/Carthage/Carthage).

Add the following to your Cartfile:

```
github "socketio/socket.io-client-swift" ~> 15.0.0
github "kishikawakatsumi/KeychainAccess" ~> 3.2.0
github "SwiftyJSON/SwiftyJSON" ~> 4.0.0
binary "https://raw.githubusercontent.com/iProov/ios/nextgen/carthage/IProov.json"
```
> **⬆️ UPGRADING NOTICE:** Take note of the new dependencies & versions!

---

> **💠 PRE-RELEASE SOFTWARE:** Take note of the nextgen-specific URL for the IProov binary. This will need to be updated once v7 is released to production.


After installation, you will need to add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

## 🚀 Get started

Before being able to launch iProov, you need to get a token to iProov against. There are 3 different token types:

1. A **verify** token - for logging in an existing user
2. An **enrol** token - for registering a new user
3. An **ID match** token - for matching a user against a scanned ID document image.

In a production app, you normally would want to obtain the token via a server-to-server back-end call. For the purposes of on-device demos/testing, we provide Swift/Alamofire sample code for obtaining tokens via [iProov API v2](https://github.com/iProov/ios/blob/nextgen/Sample%20Code/APIV2Client.swift) with our open-source [iOS API Client](https://github.com/iProov/ios-api-client).

> **⬆️ UPGRADING NOTICE:** This is a significant change from pre-v7 SDK where for ease of debugging/development, the SDK could be passed an API key and then obtain the token for you automatically. This should never have been used for production apps anyway, and the functionality is no longer part of the SDK.

Once you have obtained the token, you can simply call `IProov.launch(...)`:

```
let token = "{{ your token here }}"

IProov.launch(token: token, animated: true, callback: { (status) in

	switch status {
	case let .processing(progress, message):
		// The SDK will update your app with the progress of streaming to the server and authenticating
		// the user. This will be called multiple time as the progress updates.
	    
	case let .success(token):
	    // The user was successfully verified/enrolled and the token has been validated.
	    // The token passed back will be the same as the one passed in to the original call.
	    
	case let .failure(reason, feedback):
		// The user was not successfully verified/enrolled, as their identity could not be verified,
		// or there was another issue with their verification/enrollment, and a reason (as a string)
		// is provided as to why the claim failed.
		
	case .cancelled:
		// The user cancelled iProov, either by pressing the close button at the top right, or sending
		// the app to the background.
	    
	case let .error(error):
		// The user was not successfully verified/enrolled due to an error (e.g. lost internet connection)
		// along with an `iProovError` with more information about the error (NSError in Objective-C).
		// It will be called once, or never.
		
	}
	
}
```

By default, iProov will stream to our EU back-end platform. If you wish to stream to a different back-end, you can pass a `streamingURL` as the first parameter to `IProov.launch()` with the base URL of the back-end to stream to.

> **⚠️ SECURITY NOTICE:** You should never use iProov as a local authentication method. You cannot rely on the fact that the success result was returned to prove that the user was authenticated or enrolled successfully (it is possible the iProov process could be manipulated locally by a malicious user). You can treat the success callback as a hint to your app to update the UI, etc. but you must always independently validate the token server-side (using the validate API call) before performing any authenticated user actions.

---

> **⬆️ UPGRADING NOTICE:** In v7 you no longer need to call `IProov.verify()` or `IProov.enrol()`. There were previously 6 separate methods to launch iProov, these have now been combined into a single method. (Push & URL launched claims are no longer handled within the SDK itself).

---

> **⬆️ UPGRADING NOTICE:** Previously, after launching iProov, the SDK would handle the entire user experience end-to-end, from getting a token all the way through to the streaming UI and would then pass back a pass/fail/error result to your app. In v7, the SDK flashes the screen and then hands back control to your app, whilst the capture is streamed in the background. This means that you can now control the UI to display your own streaming UI, or allow the user to continue with another activity whilst the iProov capture streams in the background.

---

> **💠 PRE-RELEASE SOFTWARE:** Objective-C sample code is coming soon.

## ⚙ Options

You can customize the iProov session by passing in an `Options` object when launching iProov and setting any of these variables:

```swift
let options = Options()

/*
	UIOptions
	Configure options relating to the user interface
*/

options.ui.locale = Locale(identifier: "en")		// Overrides the device locale setting for the iProov SDK. Must be a 2-letter ISO 639-1 code: http://www.loc.gov/standards/iso639-2/php/code_list.php
options.ui.filter = .shaded		// Adjust the filter used for the face preview. Can be .classic (as in pre-v7), .shaded (additional detail, the default in v7) or .vibrant (full colour).

// Adjust various colors for the camera preview:
options.ui.lineColor = .white
options.ui.backgroundColor = .black
options.ui.loadingTintColor = .lightGray
options.ui.notReadyTintColor = .orange
options.ui.readyTintColor = .green

options.ui.messageHidden = false		// Hides the "Authenticate/Enrol as X" message. Default false
options.ui.regularFont = "SomeFont"
options.ui.boldFont = "SomeFont-Bold"
options.ui.fonts = ["SomeFont", "SomeFont-Bold"]		// If using custom fonts, specify them here (don't forget to add them to your Info.plist!)
options.ui.logoImage = UIImage(named: "foo")
options.ui.scanLineDisabled = false		// Disables the vertical sweeping scanline whilst flashing introduced in SDK v7
options.ui.autoStartDisabled = false		// Disable the "auto start" countdown functionality. The user will have to tap the screen to start iProoving. 


/*
	NetworkOptions
	Configure options relating to networking & security
*/

options.network.certificates = [Bundle.main.path(forResource: "custom_cert", ofType: "der")!] // Supply an array of paths of certificates to be used for pinning. Useful when using your own proxy server, or for overriding the built-in certificate pinning for some other reason. Certificates should be generated in DER-encoded X.509 certificate format, eg. with the command: $ openssl x509 -in cert.crt -outform der -out cert.der
options.network.disableCertificatePinning = false	// Disables SSL/TLS certificate pinning to the server. WARNING! Do not enable this in production apps.

/*
	CaptureOptions
	Configure options relating to the capture functionality
*/

// You can specify max yaw/roll/pitch deviation of the user's face to ensure a given pose. Values are provided in normalised units.
// These options should not be set for general use. Please contact iProov for further information if you would like to use this feature.

options.capture.maxYaw = 0.03
options.capture.maxRoll = 0.03
options.capture.maxPitch = 0.03

```

## 🌎 String localization & customization

The SDK ships with localized strings for the following locales:

- English
- Norwegian Bokmål
- Norwegian Nynosk
- Dutch
- Turkish

If the user's device language is set to one of the above, the SDK will be localized accordingingly unless `options.ui.locale` is set, in which case this setting will override the default locale.

It is also possible to manually customize any of the strings in the app, regardless of locale.

> **💠 PRE-RELEASE SOFTWARE:** More information on string customization coming soon.

## 💥 Handling failures & errors

### Failures

Failures occur when the user's identity could not be verified for some reason. A failure means that the capture was successfully received and processed by the server, which returned a result. Crucially, this differs from an error, where the capture could not be completed for some reason.

Failures are caught via the `.failure(reason, fallback)` enum case in the callback:

`reason` - The reason that the user could not be verified/enrolled. You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time

`feedback` - Where available, provides additional feedback on the reason the user could not be verified/enrolled. Some possible values are:

* `ambiguous_outcome`
* `network_problem`
* `user_timeout`

### Errors

Errors occur when the capture could not be completed due to a technical problem or user action which prevents the capture from completing. Errors originate from the device, as opposed to iProov's servers.

Errors are caught via the `.error(error)` enum case in the callback. The `error` parameter provides the reason the iProov process failed as an `IProovError`.

A description of these cases are as follows:

* `streamingError(String?)` - An error occurred with the video streaming process. Consult the error associated value for more information.
* `encoderError(code: Int32?)` - An error occurred with the video encoder. Report the error code to iProov for further assistance.
* `lightingModelError` - An error occurred with the lighting model. This should be reported to iProov for further assistance.
* `cameraError(String?)` - An error occurred with the camera.
* `cameraPermissionDenied` - The user disallowed access to the camera when prompted.
* `serverError(String?)` - A server-side error/token invalidation occurred. The associated string will contain further information about the error.

## ❓Help & support

For further help with integrating the SDK, please contact [support@iproov.com](mailto:support@iproov.com).
