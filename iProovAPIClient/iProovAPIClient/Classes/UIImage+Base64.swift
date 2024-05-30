// Copyright (c) 2024 iProov Ltd. All rights reserved.

import UIKit

extension UIImage {
    convenience init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data)
    }

    var base64String: String {
        jpegData(compressionQuality: 0.9)!.base64EncodedString()
    }
}
