//
//  RoundRectButton.swift
//  Smart Training Log
//

import UIKit

class RoundRectButton: ToggleableButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
