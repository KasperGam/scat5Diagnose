//
//  TogglableButton.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/17/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class ToggleableButton: UIButton {

    @IBInspectable var defaultOutlineColor: UIColor = .clear
    @IBInspectable var defaultBackgroundColor: UIColor = .white
    @IBInspectable var defaultOutlineWidth: CGFloat = 0.0

    @IBInspectable var disabledOutlineColor: UIColor = .clear
    @IBInspectable var disabledBackgroundColor: UIColor = .white
    @IBInspectable var disabledOutlineWidth: CGFloat = 0.0

    override func layoutSubviews() {
        super.layoutSubviews()
        if isEnabled {
            self.layer.borderWidth = self.defaultOutlineWidth
            UIView.animate(withDuration: 0.15) {
                self.layer.borderColor = self.defaultOutlineColor.cgColor
                self.backgroundColor = self.defaultBackgroundColor
            }
        } else {
            self.layer.borderWidth = self.disabledOutlineWidth
            UIView.animate(withDuration: 0.15) {
                self.layer.borderColor = self.disabledOutlineColor.cgColor
                self.backgroundColor = self.disabledBackgroundColor
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            setNeedsLayout()
        }
    }
}
