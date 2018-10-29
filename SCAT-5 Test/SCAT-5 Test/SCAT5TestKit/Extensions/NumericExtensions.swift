//
//  NumericExtensions.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/24/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

extension Int {
    func valueAsTime() -> String {
        guard self > 0 else { return "" }
        let second = self % 60
        var min = (self - second) / 60
        let hour = min / 60
        min = min - 60 * hour
        if min > 0 || hour > 0 {
            let secondStr = second < 10 ? "0\(second)" : String(second)

            if hour > 0 {
                let minStr = min < 10 ? "0\(min)" : String(min)
                return "\(hour):\(minStr):\(secondStr)"
            } else {
                return "\(min):\(secondStr)"
            }
        } else {
            return String(self)
        }
    }
}
