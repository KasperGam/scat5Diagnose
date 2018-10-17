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
        registerButton.isEnabled = false

        firstNameField.tag = 0
        lastNameField.tag = 1
        gtUserField.tag = 2
        emailField.tag = 3
        passwordField.tag = 4
        confirmPasswordField.tag = 5

        firstNameField.delegate = self
        lastNameField.delegate = self
        gtUserField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }

    @IBAction func registerPressed(_ sender: Any) {
        register()
    }

    @IBAction func editingChanged(_ sender: Any) {
        updateRegisterButton()
    }


    private func updateRegisterButton() {
        guard
            let first = firstNameField.text,
            let last = lastNameField.text,
            let gtUser = gtUserField.text,
            let email = emailField.text,
            let pass = passwordField.text,
            let confirmPass = confirmPasswordField.text
        else {
            registerButton.isEnabled = false
            return
        }

        registerButton.isEnabled =
            !first.isEmpty &&
            !last.isEmpty &&
            !gtUser.isEmpty &&
            email.isValidEmail &&
            !pass.isEmpty &&
            pass == confirmPass
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
        newUser.showInstructions = true

        auth?.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard
                let user = result?.user,
                error == nil
            else {
                self?.showAuthError(error: error)
                return
            }
            newUser.firebaseUser = user

            guard let manager = try? Container.resolve(DataManager.self) else { return }
            if !manager.registerUser(user: newUser) {
                self?.showAuthError(error: nil)
                try? self?.auth?.signOut()
            }

            if let keychain = try? Container.resolve(KeychainManager.self) {
                keychain.saveUser(email: email, password: password)
            }
            self?.performSegue(withIdentifier: "registerToHome", sender: self)
        }
    }

    func showAuthError(error: Error?) {
        let alertController = UIAlertController(title: "An Error Occured", message: error?.localizedDescription ?? "User could not be created", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            newField.becomeFirstResponder()
        } else {
            if registerButton.isEnabled {
                register()
            }
        }
        return true
    }
}
