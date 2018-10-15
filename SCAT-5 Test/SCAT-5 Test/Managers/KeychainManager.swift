//
//  KeychainManager.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainManager {

    private let emailKey = "SCAT5_USER_EMAIL"
    private let passKey = "SCAT5_USER_PASSWORD"

    func saveUser(email: String, password: String) {

        let keychain = KeychainSwift()
        keychain.set(email, forKey: emailKey)
        keychain.set(password, forKey: passKey)
    }

    func savedUserEmail() -> String? {
        return KeychainSwift().get(emailKey)
    }

    func savedUserPassword() -> String? {
        return KeychainSwift().get(passKey)
    }

}
