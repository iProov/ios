# iProov iOS API Client

## Introduction

The iProov iOS API Client is a simple wrapper for the [iProov REST API v2](https://secure.iproov.me/docs.html) written in Swift and using [Alamofire](https://github.com/Alamofire/Alamofire) & [SwiftyJSON](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON) for the HTTP networking and JSON serialization/deserialization. We also have an Android API client available [here](https://github.com/iProov/android-api-client).

## Important security notice

In production, the iProov REST API should only ever be called directly from your back-end, however this library is designed to help you with debugging/evaluating the [iProov iOS SDK](https://github.com/iProov/ios), to get up-and-running quickly with a pure on-device demo.

Use of the iOS API Client requires providing it with your API secret. **You should never embed your API secret within a production app**. 

...But of course, if by any chance you happen to use Swift on your [back](https://vapor.codes/)-[end](https://perfect.org/) then you can probably use this code on your server, with just a few modifications (for example, you will need to handle images without UIKit).

## Installation

The iOS API Client is distributed as a Cocoapods dependency. Simply add the following line to your Podfile:

```
pod 'iProovAPIClient', :git => 'https://github.com/iProov/ios-api-client.git'
```

And then run `pod install`.

## Supported functionality

- `getToken()` - Get an enrol/verify token.
- `enrolPhoto()` - Once you have an enrolment token, you can enrol a photo against it.
- `validate()` - Validates an existing token.
- `enrolPhotoAndGetVerifyToken()` - A helper function which chains together `getToken()` for the enrolment token, `enrolPhoto()` to enrol the photo, and then `getToken()` for the verify token, which you can then use to launch the SDK.

You can find the API-calling code [here](https://github.com/iProov/swift-api-client/blob/master/iProovAPIClient/Classes/APIClient.swift).

## Example

Example of using iProov API Client together with iProov to get a verify token for an existing user and then launch the iProov SDK to perform the verification using Genuine Presence Assurance:

```swift
import iProovAPIClient
import iProov

let apiClient = APIClient(baseURL: "https://eu.rp.secure.iproov.me/api/v2",
                          apiKey: "{{ Your API key }}",
                          secret: "{{ Your API secret }}")
 
apiClient.getToken(assuranceType: .genuinePresence, type: .verify, userID: "user@example.com", success: { (token) in

	IProov.launch(token: token, callback: { (status) in
		...
	})

}, failure: { (error) in

	print(error)
            
})
```

## License

The iProov iOS API Client is licensed under the BSD-3 license.
