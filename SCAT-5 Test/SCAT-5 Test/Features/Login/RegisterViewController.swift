//
//  RegisterViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {


    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var gtUserField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    var auth: Auth?

    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
    }

    @IBAction func registerPressed(_ sender: Any) {
        register()
    }

    private func register() {
        guard
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let userName = gtUserField.text,
            let email = emailField.text,
            email.isValidEmail,
            let password = passwordField.text,
            let confirmPass = confirmPasswordField.text,
            password == confirmPass
        else {
            return
            // TODO- Show user error
        }

        let newUser = SCAT5UserFlyweight()
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.gtName = userName

        auth?.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard
                let user = result?.user,
                error == nil
            else {
                return
                // TODO- Show user error
            }
            newUser.firebaseUser = user

            guard let manager = try? Container.resolve(DataManager.self) else { return }
            manager.registerUser(user: newUser)
            self?.performSegue(withIdentifier: "registerToHome", sender: self)
        }



    }

}
