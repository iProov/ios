# iProov iOS SDK (v6.0.4)

## 🤖 Introduction

iProov is an SDK providing a programmatic interface for embedding the iProov technology within a 3rd party application.

iProov has been developed as a dynamic iOS framework distributed as a Cocoapod dependency and is supported on iOS 9.0 and above with Xcode 8.0 and above.

The framework has been written in Swift 4, and we recommend use of Swift 4 for the simplest and cleanest integration, however it is also usable from within Objective-C using an ObjC compatibility layer which provides an ObjC API to access the Swift 4 code.

The framework package is provided via this repository, which contains the following:

* **README.md** -- this document
* **WaterlooBank** -- a folder containing an Xcode sample project of iProov for the fictitious “Waterloo Bank” written in Swift.
* **WaterlooBankObjC** -- a folder containing an Xcode sample project for “Waterloo Bank” written in Objective-C.
* **iProov.framework & iProov.podspec** -- these are the files which will be pulled in automatically by Cocoapods. You do not need to do anything with these files.

## 📲 Installation

1. If you are not yet using Cocoapods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing Cocoapods, [click here](https://cocoapods.org/).)

2. Add the following to your **Podfile** (inside the target section):

```ruby
pod 'iProov', :git => 'https://github.com/iProov/ios.git'
```

3. Add the following to the end of your **Podfile** (after the last `end`):

```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Socket.IO-Client-Swift'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
```

This is a workaround to allow some of the iProov dependencies to compile on Swift 3.2 from within a Swift 4 project - we hope to be able to remove this step in a later update.

4. Run `pod install`.

5. Add an `NSCameraUsageDescription` entry to your Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

You can now call one of the iProov methods to either verify an existing user, or enrol a new one.

## 🚀 Launch Modes

There are 3 primary ways iProov can be launched for enrolment or verification:

* By being called natively from within a host application. Most native apps will use this approach.

* From an iOS (APNS) push notification.

* From an iProov URL (e.g. iproov://verify?token=xxxx) in the browser (currently only Safari is supported).

You need to ensure you `import iProov` in any Swift file where you use iProov (or `#import <iProov/iProov-Swift.h>` in Objective-C).

### 1. Verify (with Service Provider)

You would use this method where you are a service provider who knows the user ID on the device. iProov will handle the entire end-to-end process of generating a new token and authenticating the user.

For a given iProov API Key (serviceProvider) and a User ID (username), this launches an iProov verify session. The presentation of the iProov view controller can optionally be animated.

After the verification process completes, the framework waits for the result of the authentication process and then calls the completion closure (or in the case of Objective-C, one of the completion blocks depending on the result).

**Swift:**
```swift
static func verify(withServiceProvider serviceProvider: String, username: String, animated: Bool, iproovConfig: IProovConfig = IProovConfig(), completion: @escaping ((Result) -> Void))
```
**Objective-C:**
```objc
+ (void)verifyWithServiceProvider:(NSString * _Nonnull)serviceProvider username:(NSString * _Nullable)username animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;
```

### 2. Verify (with Token)

You would use this method where you already have the token for the user you wish to authenticate (you have already generated this by calling the REST API from your server and now wish to authenticate the user). The other parameters are the same as verify (with Service Provider).

After the verification process completes, the framework waits for the result of the authentication process and then calls the completion closure/blocks.

**Swift:**
```swift
static func verify(withToken encryptedToken: String, serviceProvider: String, animated: Bool, iproovConfig: IProovConfig = IProovConfig(), completion: @escaping ((Result) -> Void))
```
**Objective-C:**
```objc
+ (void)verifyWithToken:(NSString * _Nonnull)encryptedToken serviceProvider:(NSString * _Nonnull)serviceProvider animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;
```

### 3. Enrol (with Service Provider)

You would use this method where you are a service provider and wish to enrol (register) a new iProov user.

For a given iProov API Key (serviceProvider) and a User ID (username), this launches an iProov enrolment session. The presentation of the iProov view controller can optionally be animated.

After the enrolment process completes, the framework waits for the result of the authentication process and then calls the completion closure/blocks.

**Swift:**
```swift
static func enrol(withServiceProvider serviceProvider: String, username: String, animated: Bool, iproovConfig: IProovConfig = IProovConfig(), completion: @escaping ((Result) -> Void))
```
**Objective-C:**
```objc
+ (void)enrolWithServiceProvider:(NSString * _Nonnull)serviceProvider username:(NSString * _Nonnull)username animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;
```

### 4. Enrol (with Token)

You would use this method where you already have the token for the user you wish to enrol (you have already generated this by calling the REST API from your server and now wish to authenticate the user). The other parameters are the same as enrol (with Service Provider).

After the enrolment process completes, the framework waits for the result of the authentication process and then calls one of the completion closure/blocks.

**Swift:**
```swift
static func enrol(withToken encryptedToken: String, serviceProvider: String, animated: Bool, iproovConfig: IProovConfig = IProovConfig(), completion: @escaping ((Result) -> Void))
```
**Objective-C:**
```objc
+ (void)enrolWithToken:(NSString * _Nonnull)encryptedToken serviceProvider:(NSString * _Nonnull)serviceProvider animated:(BOOL)animated success:(void (^ _Nonnull)(NSString * _Nonnull))success failure:(void (^ _Nonnull)(NSString * _Nonnull))failure error:(void (^ _Nonnull)(NSError * _Nonnull))error;
```

### 5. Launch (with Notification)

You would use this when you want to launch an iProov session from an incoming push notification, for authenticating with an application or service running on another device (e.g. VPN or PC software).

The method takes an iOS APNS push notification object directly and launches an iProov session based on it.

After the capture process completes, the framework waits for the result of the authentication process and then prompts the user to end the session by pressing the home button on their iOS device.

**Swift:**
```swift
static func launch(withNotification notification: [AnyHashable : Any])
```
**Objective-C:**
```objc
+ (void)launchWithNotification:(NSDictionary * _Nonnull)notification;
```

### 6. Launch (with URL)

You would use this when you want to launch an iProov session from a browser URL, perform the capture inside your host app, and then return the user to the browser to complete the authentication and complete the user journey.

The method takes an iproov:// url and launches an iProov session based on it.

After the capture process completes, the framework brings the browser back to the foreground, where the authentication process completes within the browser.

**Swift:**
```swift
static func launch(withURL url: URL)
```
**Objective-C:**
```objc
+ (void)launchWithURL:(NSURL * _Nonnull)url;
```

#### Comparison of iProov.framework launch modes:

| Launch mode | Source | Authentication | Result handling |
|-------------|--------|----------------|-----------------|
| Native | Host application | In app | Callback
| URL | URL | In browser | None
| Push | APNS notification | In app | Dialog

## 🎯 Completion Callbacks

When an iProov native claim completes (whether a verification or enrolment), there are 4 possible results:

* **success** - the user was successfully verified/enrolled, and a token is now provided for this session.

* **failure** - the user was not successfully verified/enrolled, as their identity could not be verified, or there was another issue with their verification/enrollment, and a reason (as a string) is provided as to why the claim failed.

* **error** - the user was not successfully verified/enrolled due to an error (e.g. lost internet connection, etc) along with an iProovError with more information about the error (NSError in Objective-C).

* **pending** - the user may have been successfully verified/enrolled, but the outcome of the verification/enrolment is not yet known, but will become known at a later point in time. _NOTE: The pending result is not currently returned by the native claim, and may be removed in a future update._

In Swift apps, the result is provided as an enum with associated values in the completion closure. In Objective-C apps, the result is provided via 3 separate callbacks (pending is not handled).

### success

**Swift:**
```swift
case success(token: String)
```
**Objective-C:**
```objc
(void (^ _Nonnull)(NSString * _Nonnull))token
```

The parameter is as follows:

`token` - The token that was generated for this claim.

> SECURITY WARNING: Never use iProov as a local authentication method. You cannot rely on the fact that the success result was returned to prove that the user was authenticated or enrolled successfully (it is possible the iProov process could be manipulated locally by a malicious user). You can treat the success callback as a hint to your app to update the UI, etc. but you must always independently validate the token server-side (using the validate API call) before performing any authenticated user actions.

### failure

**Swift:**
```swift
case failure(reason: String, feedback: String?))
```
**Objective-C:**
```objc
(void (^ _Nonnull)(NSString * _Nonnull))reason
```

The parameters are as follows:

`reason` - The reason that the user could not be verified/enrolled. You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time.
`feedback` - Where available, provides additional feedback on the reason the user could not be verified/enrolled. Some possible values are:

* `ambiguous_outcome`
* `network_problem`
* `user_timeout`

### error

**Swift:**
```swift
case error(error: iProov.IProovError)
```
The parameter is as follows:

`error` Provides the reason the iProov process failed as an IProovError.

The IProovError is an enum (some with associated values), and also has a method stringValues which returns a title and message that can be displayed in a dialog.

```swift
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

A description of these cases are as follows:

* **apiError** - An issue occurred with the API (e.g. timeout, disconnection, etc.). Consult the error associated value for more information.
* **streamingError** - An error occurred with the video streaming process. Consult the error associated value for more information.
* **alreadyEnrolled** - During enrolment, a user with this user ID has already enrolled.
* **unknownIdentity** - Some Service Providers will reject user IDs that have not enrolled.
* **userPressedBack** - The user voluntarily pressed the back button to end the claim.
* **userPressedHome** - The user voluntarily pressed the device’s home button to send the app to the background.
* **unsupportedDevice** - The device is not supported, i.e. does not have a front-facing camera. At present, this error should never be triggered.
* **unknownError** - An unknown error has occurred (this should not happen). If you find this returned, please let us know.

**Objective-C:**
```objc
(void (^ _Nonnull)(NSError * _Nonnull))error
```
The parameter is as follows:

`error` Provides the reason the iProov process failed as a standard NSError.

The NSError has a code which is a categorisation of the error type, and a localizedDescription which you may want to show to the user.

The possible code values are defined as follows:

```objc
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

## ⚙ Configuration Options

All launch methods can be called with an optional IProovConfig struct:

```swift
var iproovConfig = IProovConfig()
iproovConfig.autoStart = true                    //instead of requiring a user tap, auto-countdown from 3 when face is detected. Default true
iproovConfig.localeOverride = "en"               //overrides the device locale setting for the iProov SDK. Must be a 2-letter ISO 639-1 code: http://www.loc.gov/standards/iso639-2/php/code_list.php
iproovConfig.backgroundTint = UIColor.black      //background colour shown after the flashing stops. Default UIColor.black
iproovConfig.indeterminateSpinner = false        //when true, shows an indeterminate upload progress instead of a progress bar. Default false
iproovConfig.spinnerTint = UIColor.white         //only has an effect when setShowIndeterminateSpinner is true. Default UIColor.white
iproovConfig.privacyPolicyDisabled = false       //when true, prevents the privacy policy from showing on first IProov. Default false
iproovConfig.instructionsDialogDisabled = false  //when true, prevents the instructions dialog pop-up from showing. Default false
iproovConfig.messageDisabled = false             //when true, prevents the "you are about to IProov as <user>" message from showing. Default false

//change the colour of the edge and background for the starting face visualisation, for normal light and low light conditions
//NB: for low light colour scheme, please use a background colour sufficiently bright to allow the face to be illuminated for face detection purposes.
iproovConfig.startingEdgeColor = UIColor.white
iproovConfig.startingBackgroundColor = UIColor.black
iproovConfig.lowLightEdgeColor = UIColor.black
iproovConfig.lowLightBackgroundColor = UIColor.white

//fonts are identified by name and must either be system fonts or specified in a UIAppFonts array in your Info.plist
iproovConfig.regularFont = "SomeFont"            //change the default font used within the SDK 
iproovConfig.boldFont = "SomeFont-Bold"          //boldFont is used for feedback messages and the countdown timer

iproovConfig.disablePinning = false              //when true (not recommended), disables certificate pinning to the server. Default false
iproovConfig.baseURL = "https://mybackend.com"   //change the server base URL. This is an advanced setting - please contact us if you wish to use your own base URL (eg. for proxying requests)
//optionally supply an array of paths of certificates to be used for pinning. Useful when using your own baseURL or for overriding the built-in certificate pinning for some other reason.
//certificates should be generated in DER-encoded X.509 certificate format, eg. with the command $ openssl x509 -in cert.crt -outform der -out cert.der
iproovConfig.certificateFiles = [Bundle.main.path(forResource: "custom", ofType: "der")!]

IProov.verify(withServiceProvider: serviceProvider, username: username, animated: true, iproovConfig: iproovConfig) { (result) in
    switch result {
        //handle result...
    }
}

```
