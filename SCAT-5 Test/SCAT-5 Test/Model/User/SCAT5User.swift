//
//  SCAT5User.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import FirebaseAuth

protocol SCAT5User {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var firebaseUser: User? { get set }
    var gtName: String? { get set }
    var showInstructions: Bool? { get set }
}

extension SCAT5User {
    mutating func update(with model: SCAT5User) {
        firstName = model.firstName ?? firstName
        lastName = model.lastName ?? lastName
        firebaseUser = model.firebaseUser ?? firebaseUser
        gtName = model.gtName ?? gtName
        showInstructions = model.showInstructions ?? showInstructions
    }
}

class SCAT5UserFlyweight: SCAT5User, Codable {
    var firstName: String?
    var lastName: String?
    var firebaseUser: User?
    var gtName: String?
    var showInstructions: Bool?

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case gatechUsername
        case instructionsShown
        case id
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(gtName, forKey: .gatechUsername)
        try container.encodeIfPresent(showInstructions, forKey: .instructionsShown)
        if let user = firebaseUser {
            try container.encode(user.uid, forKey: .id)
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        gtName = try container.decodeIfPresent(String.self, forKey: .gatechUsername)
        showInstructions = (try? container.decodeIfPresent(Bool.self, forKey: .instructionsShown)) ?? true
    }

    init(){}

}
