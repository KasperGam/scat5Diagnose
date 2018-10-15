//
//  LoginViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var auth: Auth?

    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
    }

    @IBAction func loginPressed(_ sender: Any) {
        login()
    }

    private func login() {
        guard
            let email = emailField.text,
            email.isValidEmail,
            let password = passwordField.text
        else {
            return
            // TODO- Show Error
        }

        auth?.signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard
                let user = result?.user,
                error == nil
            else {
                // Display error
                return
            }

            guard let manager = try? Container.resolve(DataManager.self) else { return }
            manager.loginUser(user: user)
            self?.performSegue(withIdentifier: "loginToHome", sender: self)
        }

    }

}
