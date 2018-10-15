//
//  UIImageExtensions.swift
//  Smart Training Log
//

import UIKit

extension UIImage {

    func compressed(to bytes: Int) -> Data? {
        guard var data = self.pngData() else { return nil }
        while data.count > bytes {
            let compressionRatio: CGFloat = 0.9
            if let newData = self.jpegData(compressionQuality: compressionRatio) {
                data = newData
            } else {
                return nil
            }
        }
        return data
    }

}
