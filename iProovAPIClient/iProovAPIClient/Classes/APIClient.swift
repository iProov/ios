// Copyright (c) 2024 iProov Ltd. All rights reserved.

// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
//    THIS CODE IS PROVIDED FOR DEMO PURPOSES ONLY AND SHOULD NOT BE USED IN
//  PRODUCTION! YOU SHOULD NEVER EMBED YOUR CREDENTIALS IN A PUBLIC APP RELEASE!
//      THESE API CALLS SHOULD ONLY EVER BE MADE FROM YOUR BACK-END SERVER
// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

import Alamofire
import Foundation

typealias JSON = [String: Any]

private let appID = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String

public enum ClaimType: String {
    case enrol, verify
}

public enum AssuranceType: String {
    case genuinePresence = "genuine_presence"
    case liveness
}

public class APIClient {
    private let baseURL: String
    private let apiKey: String
    private let secret: String

    public enum PhotoSource: String {
        case electronicID = "eid"
        case opticalID = "oid"
    }

    public enum Error: Swift.Error, LocalizedError {
        case invalidImage, noToken, invalidJSON, serverError(String)

        public var errorDescription: String? {
            switch self {
            case .invalidImage:
                "Invalid image"
            case .noToken:
                "No token"
            case .invalidJSON:
                "Invalid JSON"
            case let .serverError(errorDescription):
                errorDescription
            }
        }
    }

    public init(baseURL: String, apiKey: String, secret: String) {
        #warning("You should never embed your API key/secret in client code!")

        var baseURL = baseURL

        if baseURL.hasSuffix("/") {
            baseURL = String(baseURL.dropLast())
        }

        if !baseURL.hasSuffix("/api/v2") {
            baseURL.append("/api/v2")
        }

        self.baseURL = baseURL
        self.apiKey = apiKey
        self.secret = secret
    }

    public func getToken(assuranceType: AssuranceType,
                         type: ClaimType,
                         userID: String,
                         resource: String? = nil,
                         additionalOptions: [String: Any] = [:],
                         completion: @escaping (Result<String, Swift.Error>) -> Void)
    {
        let url = String(format: "%@/claim/%@/token", baseURL, type.rawValue)

        var params: [String: Any] = [
            "assurance_type": assuranceType.rawValue,
            "api_key": apiKey,
            "secret": secret,
            "resource": resource ?? appID,
            "client": "ios",
            "user_id": userID,
        ]

        for (key, value) in additionalOptions {
            params[key] = value
        }

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 500)
            .responseToken(completionHandler: completion)
    }

    public func enrolPhoto(token: String,
                           image: UIImage,
                           source: PhotoSource,
                           completion: @escaping (Result<String, Swift.Error>) -> Void)
    {
        let url = String(format: "%@/claim/enrol/image", baseURL)

        guard let jpegData = image.safeJPEGData(compressionQuality: 1.0) else {
            completion(.failure(Error.invalidImage))
            return
        }

        AF.upload(multipartFormData: { multipartFormData in

            multipartFormData.append(self.apiKey, withName: "api_key")
            multipartFormData.append(self.secret, withName: "secret")
            multipartFormData.append(0, withName: "rotation")
            multipartFormData.append(token, withName: "token")
            multipartFormData.append(jpegData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            multipartFormData.append(source.rawValue, withName: "source")

        }, to: url)
            .validate(statusCode: 200 ..< 500)
            .responseToken(completionHandler: completion)
    }

    public func validate(token: String,
                         userID: String,
                         completion: @escaping (Result<ValidationResult, Swift.Error>) -> Void)
    {
        let url = String(format: "%@/claim/verify/validate", baseURL)

        let params = [
            "api_key": apiKey,
            "secret": secret,
            "user_id": userID,
            "token": token,
            "ip": "127.0.0.1",
            "client": appID,
            "risk_profile": "",
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 500)
            .responseData { response in

                switch response.result {
                case let .success(data):

                    guard let json = try? JSONSerialization.jsonObject(with: data) as? JSON else {
                        completion(.failure(Error.invalidJSON))
                        return
                    }

                    if let errorDescription = json["error_description"] as? String {
                        completion(.failure(Error.serverError(errorDescription)))
                        return
                    }

                    let validationResult = ValidationResult(json: json)
                    completion(.success(validationResult))

                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}

public extension APIClient {
    private struct ErrorSink<T> {
        let failure: (Swift.Error) -> Void

        func onSuccess(_ next: @escaping (T) -> Void) -> (Result<T, Swift.Error>) -> Void {
            { result in
                switch result {
                case let .success(value):
                    next(value)
                case let .failure(error):
                    failure(error)
                }
            }
        }
    }

    // This helper function chains together the 3 calls needed to enrol photo and get a token to iProov against:
    func enrolPhotoAndGetVerifyToken(userID: String,
                                     image: UIImage,
                                     source: PhotoSource,
                                     completion: @escaping (Result<String, Swift.Error>) -> Void)
    {
        let errorSink = ErrorSink<String> { completion(.failure($0)) }

        getToken(assuranceType: .genuinePresence, type: .enrol, userID: userID, completion: errorSink.onSuccess { token in
            self.enrolPhoto(token: token, image: image, source: source, completion: errorSink.onSuccess { _ in
                self.getToken(assuranceType: .genuinePresence, type: .verify, userID: userID, completion: completion)
            })
        })
    }
}

public extension DataRequest {
    @discardableResult
    func responseToken(completionHandler: @escaping (Result<String, Swift.Error>) -> Void) -> Self {
        responseData { response in
            switch response.result {
            case let .success(data):

                guard let json = try? JSONSerialization.jsonObject(with: data) as? JSON else {
                    completionHandler(.failure(APIClient.Error.invalidJSON))
                    return
                }

                if let errorDescription = json["error_description"] as? String {
                    completionHandler(.failure(APIClient.Error.serverError(errorDescription)))
                    return
                }

                guard let token = json["token"] as? String else {
                    completionHandler(.failure(APIClient.Error.noToken))
                    return
                }

                completionHandler(.success(token))

            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
