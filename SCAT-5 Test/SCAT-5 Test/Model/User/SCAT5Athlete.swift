//
//  SCAT5Athlete.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

protocol SCAT5Athlete {
    var dob: Date? { get set }
    var id: String? { get set }
    var name: String? { get set }
    var profileImage: UIImage? { get set }
    var assessments: [SCAT5Test]? { get set }

    func dobString() -> String?
}

extension SCAT5Athlete {
    mutating func update(with model: SCAT5Athlete) {
        dob = model.dob ?? dob
        id = model.id ?? id
        name = model.name ?? name
    }
}

class SCAT5AthleteFlyweight: SCAT5Athlete, Codable {
    var dob: Date?
    var id: String?
    var name: String?
    var profileImage: UIImage?
    var assessments: [SCAT5Test]?

    var formatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.calendar = Calendar.current
            formatter.dateFormat = "MM/dd/yyyy"
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

    init() {}

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

    func hashedID() -> String {
        guard let name = name, let dob = dobString() else { return ""}
        let str = name + " " + dob
        return str.sha256().uppercased()
    }

    func imageName() -> String {
        guard
            let name = name,
            let dob = dob
        else {
            return ""
        }
        var newStr = name + formatter.string(from: dob)
        newStr = newStr.replacingOccurrences(of: " ", with: "")
        return newStr.replacingOccurrences(of: "/", with: "").lowercased() + ".jpg"
    }
}
