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

    let passChangeAlertController: UIAlertController = UIAlertController(title: "Change Password", message: "Change password: ", preferredStyle: UIAlertController.Style.alert)

    @IBOutlet weak var showInstructionsSwitch: UISwitch!

    var user: SCAT5User?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        user = manager.currentUser
        showInstructionsSwitch.isOn = user?.showInstructions ?? true

        passChangeAlertController.addTextField(configurationHandler: nil)

        passChangeAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.updatePassword(with: strongSelf.passChangeAlertController.textFields?.first?.text)
            strongSelf.passChangeAlertController.dismiss(animated: true, completion: nil)
        }))

        passChangeAlertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak self] (_) in
            self?.passChangeAlertController.dismiss(animated: true, completion: nil)
        }))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        user?.showInstructions = showInstructionsSwitch.isOn
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        _ = manager.updateCurrentUser(with: user)
    }



    @IBAction func ChangePasswordPressed(_ sender: Any) {
        // TODO- Implement Change Password
        present(passChangeAlertController, animated: true, completion: nil)
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

    private func updatePassword(with password: String?) {
        guard let pass = password else { return }
        let auth = Auth.auth()
        auth.currentUser?.updatePassword(to: pass, completion: { [weak self] (error) in
            if let errorMsg = error?.localizedDescription {
                let passChangeErrorAlertController: UIAlertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                passChangeErrorAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                    passChangeErrorAlertController.dismiss(animated: true, completion: nil)
                    self?.present(passChangeErrorAlertController, animated: true, completion: nil)
                }))
            }
        })
    }

}
