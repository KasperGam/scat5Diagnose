//
//  UITextFieldExtensions.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/29/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
