// Copyright (c) 2021 iProov Ltd. All rights reserved.

import UIKit

extension UIImage {
    /* UIImage.jpegData() returns nil for non-CGImage backed UIImages, for example those generated from Core Image.
     This method is safer as it will attempt to re-draw the image to a new context if necessary.
     */
    func safeJPEGData(compressionQuality: CGFloat) -> Data? {
        guard cgImage == nil else {
            return jpegData(compressionQuality: compressionQuality)
        }

        guard let ciImage = ciImage,
            let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent)
        else { return nil }

        return UIImage(cgImage: cgImage).jpegData(compressionQuality: compressionQuality)
    }
}
