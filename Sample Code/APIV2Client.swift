//
//  APIV2Client.swift
//  iProov Sample Code
//
//  Created by Jonathan Ellis on 01/04/2019.
//  Copyright © 2019 iProov Limited. All rights reserved.
//

// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
//    THIS CODE IS PROVIDED FOR DEMO PURPOSES ONLY AND SHOULD NOT BE USED IN
//  PRODUCTION! YOU SHOULD NEVER EMBED YOUR CREDENTIALS IN A PUBLIC APP RELEASE!
//      THESE API CALLS SHOULD ONLY EVER BE MADE FROM YOUR BACK-END SERVER
// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

import Foundation
import Alamofire

enum ClaimType: String {
    case enrol, verify
}

class APIV2Client {

    private let baseURL: String
    private let apiKey: String
    private let secret: String

    init(baseURL: String = "https://eu.rp.secure.iproov.me", apiKey: String, secret: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.secret = secret
    }

    func getToken(type: ClaimType, userID: String, success: @escaping (_ token: String) -> Void, failure: @escaping (Error) -> Void) {

        let url = String(format: "%@/api/v2/claim/%@/token", baseURL, type.rawValue)

        let appId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String

        let params = [
            "api_key": apiKey,
            "resource": appId,
            "client": "ios",
            "secret": secret,
            "user_id": userID
        ]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding(), headers: nil).responseSwiftyJSON { (response) in

            switch response.result {
            case let .success(json):
                let token = json["token"].stringValue
                success(token)

            case let .failure(error):
                failure(error)

            }
        }

    }

}
