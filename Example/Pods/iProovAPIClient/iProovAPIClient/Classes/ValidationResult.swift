// Copyright (c) 2021 iProov Ltd. All rights reserved.

import Foundation
import SwiftyJSON

public struct ValidationResult {
    public let isPassed: Bool
    public let token: String
    public let frame: UIImage?
    public let failureReason: String?

    init(json: JSON) {
        isPassed = json["passed"].boolValue
        token = json["token"].stringValue
        frame = json["frame"].base64EncodedImage
        failureReason = json["result"]["reason"].string
    }
}
