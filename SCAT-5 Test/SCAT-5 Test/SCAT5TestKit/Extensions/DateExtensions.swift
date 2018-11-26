//
//  DateExtensions.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/17/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

extension Date {

    static func currentTimeInCurrentTimeZone() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        let timeZoneDate = cal.date(from: cal.dateComponents([.day, .month, .year, .minute, .second, .hour], from: Date()))
        return timeZoneDate ?? Date()
    }

    static var formatterForMMddYYYYHHmma: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm a"
        return formatter
    }

    func getMMddYYYYHHmma() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm a"
        return formatter.string(from: self)
    }

    init(fromMMddYYYYHHmma: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm a"
        self.init()
        self = formatter.date(from: fromMMddYYYYHHmma) ?? self
    }

}
