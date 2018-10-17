//
//  SettingsViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {


    @IBOutlet weak var showInstructionsSwitch: UISwitch!

    var user: SCAT5User?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        user = manager.currentUser
        showInstructionsSwitch.isOn = user?.showInstructions ?? true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        user?.showInstructions = showInstructionsSwitch.isOn
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        _ = manager.updateCurrentUser(with: user)
    }



    @IBAction func ChangePasswordPressed(_ sender: Any) {
        // TODO- Implement Change Password
    }

    @IBAction func signOutPressed(_ sender: Any) {
        let auth = Auth.auth()
        try? auth.signOut()
        if let keychain = try? Container.resolve(KeychainManager.self) {
            keychain.resetUser()
        }

        if let manager = try? Container.resolve(DataManager.self) {
            manager.currentUser = nil
        }
        performSegue(withIdentifier: "signOutSegue", sender: self)
    }

}
