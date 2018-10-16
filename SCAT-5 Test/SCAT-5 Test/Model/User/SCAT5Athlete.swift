//
//  SCAT5Athlete.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

protocol SCAT5Athlete {
    var dob: Date? { get set }
    var id: String? { get set }
    var name: String? { get set }

    func dobString() -> String?
}

class SCAT5AthleteFlyweight: SCAT5Athlete, Codable {
    var dob: Date?
    var id: String?
    var name: String?

    var formatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY"
            return formatter
        }
    }

    func dobString() -> String? {
        if let dob = dob {
            return formatter.string(from: dob)
        } else {
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case DOB
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dateStr = try? container.decode(String.self, forKey: .DOB) {
            dob = formatter.date(from: dateStr)
        }
        name = try? container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let dob = dob {
        let dateStr = formatter.string(from: dob)
            try container.encode(dateStr, forKey: .DOB)
        }
        try container.encodeIfPresent(name, forKey: .name)
    }
}
