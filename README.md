# iProov iOS SDK v6.0.2
#### Technical Documentation
#### Peter Rocker - Last updated 11/10/17

iProov is an SDK providing a programmatic interface for embedding the iProov technology within a 3rd party application.

iProov has been developed as a dynamic iOS framework distributed as a Cocoapod dependency and is supported on iOS 9.0 and above with Xcode 8.0 and above.

The framework has been written in Swift 3, and we recommend use of Swift 3 for the simplest and cleanest integration, however it is also usable from within Objective-C using an ObjC compatibility layer which provides an ObjC API to access the Swift 3 code.

The framework package is provided via this repository, which contains the following:

* **README.md** -- this document
* **WaterlooBank** -- a folder containing an Xcode sample project of iProov for the fictitious “Waterloo Bank” written in Swift.
* **WaterlooBankObjC** -- a folder containing an Xcode sample project for “Waterloo Bank” written in Objective-C.
* **iProov.framework & iProov.podspec** -- these are the files which will be pulled in automatically by Cocoapods. You do not need to do anything with these files.

## Installation

> NOTE: If you are upgrading from an older version of the iProov SDK, please see the Upgrade Guide in the next section before following these instructions.

1. If you are currently using Swift 2.x, you must first upgrade your app to Swift 3.1 (or above).

> NOTE: iProov SDK v5.1 and above is only compatible with Swift 3.1 and above. If you require support for Swift 3.0, you should continue using iProov 5.0. If you require support for Swift 2.x, you should continue using iProov v4.x in your app.

2. If you are not yet using Cocoapods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing Cocoapods, [click here](https://cocoapods.org/).)

3. Add the following to your Podfile (inside the target section):

```
pod 'iProov', :git => 'https://github.com/iProov/ios.git'
```

4. Run `pod install`.

5. Add an `NSCameraUsageDescription` entry to your Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

You can now call one of the iProov methods to either verify an existing user, or enrol a new one.


## Upgrade Guide

If you are upgrading from a previous version of iProov, please note the following:-

1. iProov is no longer distributed as a Git submodule, please use Cocoapods instead. Cocoapods allows much easier integration with your project, simpler integration with other libraries, and better distribution and version management.

2. iProov is only compatible with Swift 3.1+ and Objective-C in Xcode 8. Please upgrade your project to Swift 3.1 before upgrading to iProov 5.x.

3. Before upgrading your project, please remove iProov.framework, GPUImage.framework and SSKeychain.framework from your project, as all dependencies will now be handled automatically by Cocoapods.

4. Please follow the “Installation” steps in the previous chapter to integrate Cocoapods with your project (if you haven’t already) and install iProov 5.x in your Xcode project.

5. The public APIs of iProov have changed, and you will need to update your iProov method calls. Please consult the guide below for the new public iProov methods. The new APIs have been designed to be more Swift 3-like, make better use of Swift language features and conventions, as well as being easier to use. We always try and avoid making breaking API changes, however with the release of Swift 3 and iProov 5.0 we have taken this opportunity to fully modernise our API.

## Important Note: Certificate Pinning

SDK versions 5.3.0 and above now implement certificate pinning by default. This improves the security of SSL transport, but means you will need to release a new build of your application with an updated SDK if the remote certificate ever changes. A new configuration option to disable pinning is now available (see below) if required.

## Launch Modes

There are 3 primary ways iProov can be launched for enrolment or verification:

* By being called natively from within a host application. Most native apps will use this approach.

* From an iProov URL (e.g. iproov://verify/xxxxxxx) from an iProov IFrame running in the browser (currently only Mobile Safari is supported).

* From an iOS (APNS) push notification.

You need to ensure you `import iProov` in any Swift file where you use iProov (or `#import <iProov/iProov-Swift.h>` in Objective-C).

### 1. Launch from a native framework method call

#### _Verify with Service Provider_

Swift: `static func verify(withServiceProvider serviceProvider: String, username: String?, animated: Bool, completion: @escaping ((iProov.Result) -> Void))`

Objective-C: `+ (void)verifyWithServiceProvider:(NSString * _Nonnull)serviceProvider username:(NSString * _Nullable)username animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;`

You would use this method where you are a service provider who knows the username you want to authenticate against, but nothing else. iProov will handle the entire end-to-end process of generating a new token and authenticating the user.

For a given iProov serviceProvider (an API key for a service provider) and a username (optional, only required for verify) launches an iProov verify session. The presentation of the iProov view controller can optionally be animated.

After the verification process completes, the framework waits for the result of the authentication process and then calls the completion closure (or in the case of Objective-C, one of the completion blocks depending on the result).

#### _Verify with Token_

Swift: `static func verify(withToken encryptedToken: String, username: String, animated: Bool, completion: @escaping ((iProov.Result) ->Void))`

Objective-C: `+ (void)verifyWithToken:(NSString * _Nonnull)encryptedToken username:(NSString * _Nonnull)username animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;`

You would use this method where you already have the encrypted token for the user you wish to authenticate (you may have already generated this elsewhere and now wish to authenticate the user). The other parameters are exactly the same as verify (withServiceProvider…).

After the verification process completes, the framework waits for the result of the authentication process and then calls the completion closure/blocks.

#### _Enrol with Service Provider_

Swift: `static func enrol(withServiceProvider serviceProvider: String, username: String!, animated: Bool, completion: @escaping ((iProov.Result) -> Void))`

Objective-C: `+ (void)enrolWithServiceProvider:(NSString * _Nonnull)serviceProvider username:(NSString * _Nonnull)username animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;`

You would use this method where you are a service provider and wish to enrol (register) a new iProov user.

For a given iProov serviceProvider and username, launches an iProov enrolment session. The presentation of the iProov view controller can optionally be animated.

After the enrolment process completes, the framework waits for the result of the authentication process and then calls the completion closure/blocks.

#### _Enrol with Token_

Swift: `static func enrol(withToken encryptedToken: String, username: String!, animated: Bool, completion: @escaping ((iProov.Result) -> Void))`

Objective-C: `+ (void)enrolWithToken:(NSString * _Nonnull)encryptedToken username:(NSString * _Nonnull)username animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;`

You would use this method where you already have the encrypted token for the user you wish to enrol (you may have already generated this elsewhere and now wish to enrol the user). The other parameters are exactly the same as enrol(withServiceProvider…).

After the enrolment process completes, the framework waits for the result of the authentication process and then calls one of the completion closure/blocks.

#### Configuration Options

The above methods can now be called with an optional IProovConfig struct:

```
  var iproovConfig = IProovConfig()
  iproovConfig.autoStart = true //instead of requiring a user tap, auto-countdown from 3 when face is detected. Default true
  iproovConfig.localeOverride = "en" //overrides the device locale setting for the iProov SDK. Must be a 2-letter ISO 639-1 code: http://www.loc.gov/standards/iso639-2/php/code_list.php
  iproovConfig.backgroundTint = UIColor.black //background colour shown after the flashing stops. Default UIColor.black
  iproovConfig.indeterminateSpinner = false //when true, shows an indeterminate upload progress instead of a progress bar. Default false
  iproovConfig.spinnerTint = UIColor.white //only has an effect when setShowIndeterminateSpinner is true. Default UIColor.white
  iproovConfig.privacyPolicyDisabled = false //when true, prevents the privacy policy from showing on first IProov. Default false
  iproovConfig.instructionsDialogDisabled = false //when true, prevents the instructions dialog pop-up from showing. Default false
  iproovConfig.messageDisabled = false //when true, prevents the "you are about to IProov as <user>" message from showing. Default false

  //change the colour of the edge and background for the starting face visualisation, for normal light and low light conditions
  //NB: for low light colour scheme, please use a background colour sufficiently bright to allow the face to be illuminated for face detection purposes.
  iproovConfig.startingEdgeColor = UIColor.white
  iproovConfig.startingBackgroundColor = UIColor.black
  iproovConfig.lowLightEdgeColor = UIColor.black
  iproovConfig.lowLightBackgroundColor = UIColor.white
    

  iproovConfig.disablePinning = false //when true (not recommended), disables certificate pinning to the server. Default false
  iproovConfig.baseURL = "https://mybackend.com" //change the server base URL. This is an advanced setting - please contact us if you wish to use your own base URL (eg. for proxying requests)
  iproovConfig.certificateFiles = [Bundle.main.path(forResource: "custom", ofType: "der")!] //optionally supply an array of paths of certificates to be used for pinning. Useful when using your own baseURL or for overriding the built-in certificate pinning for some other reason.
      //certificates should be generated in DER-encoded X.509 certificate format, eg. with the command $ openssl x509 -in cert.crt -outform der -out cert.der

  IProov.verify(withServiceProvider: serviceProvider, username: username, animated: true, iproovConfig: iproovConfig) { (result) in

    ...

```

### 2. Launch with URL

Swift: `static func launch(withURL url: URL)`

Objective-C: `+ (void)launchWithURL:(NSURL * _Nonnull)url;`

You would use this launch mode where you want to launch an iProov session from a browser URL, perform the capture inside your host app, and then return the user to the browser to complete the authentication and complete the user journey.

The method takes an iproov:// url and launches an iProov session based on it.

After the capture process completes, the framework brings the browser back to the foreground, where the authentication process completes within the browser.

### 3. Launch with Notification

Swift: `static func launch(withNotification notification: [AnyHashable : Any])`

Objective-C: `+ (void)launchWithNotification:(NSDictionary * _Nonnull)notification;`

You would use this launch mode where you want to launch an iProov session from an incoming push notification, for authenticating with an application or service running on another device (e.g. VPN or PC software).

The method takes an iOS APNS push notification object directly and launches an iProov session based on it.

After the capture process completes, the framework waits for the result of the authentication process and then prompts the user to end the session by pressing the home button on their iOS device.

Comparison of iProov.framework launch modes:

| Launch mode | Source | Authentication | Result handling |
|-------------|--------|----------------|-----------------|
| Native | Host application | In app | Callback
| URL | URL | In browser | None
| Push | APNS notification | In app | Dialog

## Completion Callbacks

When an iProov native claim completes (whether a verification or enrolment), there are 4 possible results:

* **success** - the user was successfully verified/enrolled, and a token is now provided for this user.

* **failure** - the user was not successfully verified/enrolled, as their identity could not be verified, or there was another issue with their verification/enrollment, and a reason (as a string) is provided as to why the claim failed.

* **error** - the user was not successfully verified/enrolled due to an error (e.g. lost internet connection, etc) along with an iProovError with more information about the error (NSError in Objective-C).

* **pending** - the user may have been successfully verified/enrolled, but the outcome of the verification/enrolment is not yet known, but will become known at a later point in time. _NOTE: The pending result is not currently returned by the native claim, and may be removed in a future update._

In Swift apps, the result is provided as an enum with associated values in the completion closure. In Objective-C apps, the result is provided via 3 separate callbacks (pending is not handled).

#### success

Swift: `case success(token: String)`

Objective-C: `(void (^ _Nonnull)(NSString * _Nonnull))token`

The parameter is as follows:

`token` - The token that was generated for this claim.

SECURITY WARNING: Never use iProov as a local authentication method. You cannot rely on the fact that the success result was returned to prove that the user was authenticated or enrolled successfully (it is possible the iProov process could be manipulated locally by a malicious user). You can treat the success callback as a hint to your app to update the UI, etc. but you must always independently validate the token server-side before performing any authenticated user actions.

#### failure

Swift: `case failure(reason: String, feedback: String?))`

Objective-C: `(void (^ _Nonnull)(NSString * _Nonnull))reason`

The parameter is as follows:

`reason` - The reason that the user could not be verified/enrolled. You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time.
`feedback` - Where available, provides additional feedback on the reason the user could not be verified/enrolled. Some possible values are:

* `ambiguous_outcome`
* `network_problem`

#### error

Swift: `case error(error: iProov.IProovError)`

Objective-C: `(void (^ _Nonnull)(NSError * _Nonnull))error`

The parameter is as follows:

`error` Provides the reason the iProov process failed. This is an IProovError in Swift, and a standard NSError in Objective-C.

**_Swift:_**

The IProovError is an enum (some with associated values), and also has a method stringValues which returns a title and message that can be displayed in a dialog.

```
public enum IProovError : Error, Equatable {
    case apiError(String?)
    case streamingError(String?)
    case unknownIdentity
    case alreadyEnrolled
    case userPressedBack
    case userPressedHome
    case unsupportedDevice
    case unknownError(String?)
    public var stringValues: (String, String?) { get }
}
```

A description of these cases is as follows:

* **apiError** - An issue occurred with the API (e.g. timeout, disconnection, etc.). Consult the error associated value (or localizedDescription in Objective-C) for more information.
* **streamingError** - An error occurred with the video streaming process. Consult the error associated value (or localizedDescription in Objective-C) for more information.
* **alreadyEnrolled** - During enrolment, a user with this username has already enrolled.
* **unknownIdentity** - Some Service Providers will reject invalid usernames.
* **userPressedBack** - The user voluntarily pressed the back button to end the claim
* **userPressedHome** - The user voluntarily pressed the device’s home button to send the app to the background.
* **unsupportedDevice** - The device is not supported, i.e. does not have a front-facing camera. At present, this error should never be triggered.
* **unknownError** - An unknown error has occurred (this should not happen!). If you find this returned please contact support@iproov.com

**_Objective-C:_**

The NSError has a code which is a categorisation of the error type, and a localizedDescription which you may want to show to the user.

The possible code values are defined as follows:

```
typedef SWIFT_ENUM(NSInteger, IProovErrorCode) {
  IProovErrorCodeAPIError = 1000,
  IProovErrorCodeStreamingError = 1001,
  IProovErrorCodeUnknownIdentity = 2000,
  IProovErrorCodeAlreadyEnrolled = 2001,
  IProovErrorCodeUserPressedBack = 3000,
  IProovErrorCodeUserPressedHome = 3001,
  IProovErrorCodeUnsupportedDevice = 9000,
  IProovErrorCodeUnknownError = 9999,
};
```
