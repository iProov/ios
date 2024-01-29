// Copyright (c) 2024 iProov Ltd. All rights reserved.

import Foundation

public struct ValidationResult: CustomStringConvertible {
    public let isPassed: Bool
    public let token: String
    public let type: String
    public let isFrameAvailable: Bool?
    public let frame: UIImage?
    public let failureReason: String?
    public let riskProfile: String?
    public let assuranceType: String?
    public let signals: [String: Any]?

    enum Keys {
        static let isPassed = "passed"
        static let token = "token"
        static let type = "type"
        static let isFrameAvailable = "frame_available"
        static let frame = "frame"
        static let failureReason = "reason"
        static let riskProfile = "risk_profile"
        static let assuranceType = "assurance_type"
        static let signals = "signals"
    }

    init(json: JSON) {
        isPassed = json[Keys.isPassed] as! Bool
        token = json[Keys.token] as! String
        type = json[Keys.type] as! String
        isFrameAvailable = json[Keys.isFrameAvailable] as? Bool

        if let frameBase64 = json[Keys.frame] as? String {
            frame = UIImage(base64String: frameBase64)
        } else {
            frame = nil
        }

        failureReason = json[Keys.failureReason] as? String
        riskProfile = json[Keys.riskProfile] as? String
        assuranceType = json[Keys.assuranceType] as? String
        signals = json[Keys.signals] as? JSON
    }

    public var description: String {
        var baseDescription =
            """
            Validation: \(isPassed)
            \(Keys.token): \(token)
            \(Keys.type): \(type)
            """

        if let isFrameAvailable {
            baseDescription += "\n\(Keys.isFrameAvailable): \(isFrameAvailable)"
        }

        if let riskProfile {
            baseDescription += "\n\(Keys.riskProfile): \(riskProfile)"
        }

        if let failureReason {
            baseDescription += "\n\(Keys.failureReason): \(failureReason)"
        }

        if let assuranceType {
            baseDescription += "\n\(Keys.assuranceType): \(assuranceType)"
        }

        if let signals {
            baseDescription += "\n\(Keys.signals): \(signals)"
        }

        return baseDescription
    }
}
