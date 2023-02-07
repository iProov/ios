// Copyright (c) 2023 iProov Ltd. All rights reserved.

import Foundation

public struct ValidationResult {
    public let isPassed: Bool
    public let token: String
    public let frame: UIImage?
    public let failureReason: String?

    init(json: JSON) {
        isPassed = json["passed"] as! Bool
        token = json["token"] as! String
        if let frameBase64 = json["frame"] as? String {
            frame = UIImage(base64String: frameBase64)
        } else {
            frame = nil
        }

        if let resultJSON = json["result"] as? JSON {
            failureReason = resultJSON["reason"] as? String
        } else {
            failureReason = nil
        }
    }
}
