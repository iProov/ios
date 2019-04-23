//
//  OrchestrationAPIClient.swift
//  iProov Sample Code
//
//  Created by Jonathan Ellis on 17/12/2018.
//  Copyright © 2018 iProov Limited. All rights reserved.
//

// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
//    THIS CODE IS PROVIDED FOR DEMO PURPOSES ONLY AND SHOULD NOT BE USED IN
//  PRODUCTION! YOU SHOULD NEVER EMBED YOUR CREDENTIALS IN A PUBLIC APP RELEASE!
//      THESE API CALLS SHOULD ONLY EVER BE MADE FROM YOUR BACK-END SERVER
// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

import Foundation
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

enum ClaimType: String {
    case enrol, verify
}

class OrchestrationAPIClient {

    typealias GetTokenSuccess = (_ token: String, _ streamingURL: String) -> ()
    typealias GetTokenFailure = (Error) -> ()

    enum OrchestrationAPIClientError: Error {
        case unknownError(String)
    }

    private let sessionManager = SessionManager()
    private let baseURL: String
    
    init(baseURL: String = "https://iproov.cloud/api/v1", username: String, password: String) {
        self.baseURL = baseURL
        
        let authHandler = AuthHandler(baseURL: baseURL, username: username, password: password)
        sessionManager.adapter = authHandler
        sessionManager.retrier = authHandler
    }

    func getToken(type: ClaimType, userID: String, success: @escaping GetTokenSuccess, failure: @escaping GetTokenFailure) {
        
        let params = [
            "user_id": userID,
            "type": type.rawValue
        ]
        
        sessionManager.request(baseURL + "/token", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseSwiftyJSON { (response) in
                
                switch response.result {
                case let .success(json):
                    
                    if let error = json["error"].string {
                        failure(OrchestrationAPIClientError.unknownError(error))
                        return
                    }
                    
                    let token           = json["token"].stringValue
                    let streamingURL    = json["streaming_url"].stringValue
                    success(token, streamingURL)
                    
                case let .failure(error):
                    failure(error)
                    
                }
                
        }
        
    }
    
}

private enum AuthHandlerError: Error {
    case noAccessToken
}

private class AuthHandler: RequestAdapter, RequestRetrier {
    
    private let baseURL: String
    private let username: String
    private let password: String
    
    init(baseURL: String, username: String, password: String) {
        self.baseURL = baseURL
        self.username = username
        self.password = password
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            throw AuthHandlerError.noAccessToken     // Avoid requests being made if we don't have an access token: https://github.com/Alamofire/Alamofire/issues/2517 - will be fixed in AF5.
        }
        
        var urlRequest = urlRequest // Create a mutable copy
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse {
            guard response.statusCode == 401 else {
                completion(false, 0)
                return
            }
        } else if let error = error as? AuthHandlerError {
            guard case .noAccessToken = error else {
                completion(false, 0)
                return
            }
        }
        
        let params = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(baseURL + "/auth", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseSwiftyJSON { (response) in
                
                switch response.result {
                case let .success(json):
                    
                    guard !json["error"].exists() else {
                        completion(false, 0)
                        return
                    }
                    
                    let token = json["token"].stringValue
                    UserDefaults.standard.set(token, forKey: "AccessToken")
                    completion(true, 0)
                    
                case .failure(_):
                    completion(false, 0)
                    
                }
                
        }
        
    }
    
}
