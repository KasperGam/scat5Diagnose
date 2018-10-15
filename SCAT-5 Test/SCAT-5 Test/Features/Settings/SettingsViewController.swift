//
//  SettingsViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

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
        manager.updateCurrentUser(with: user)
    }



    @IBAction func ChangePasswordPressed(_ sender: Any) {
        // TODO- Implement Change Password
    }

}
