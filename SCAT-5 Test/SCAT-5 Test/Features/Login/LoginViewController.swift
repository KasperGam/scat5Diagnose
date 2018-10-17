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
        emailField.tag = 0
        passwordField.tag = 1
        emailField.delegate = self
        passwordField.delegate = self
        auth = Auth.auth()
        if let keychain = try? Container.resolve(KeychainManager.self) {
            emailField.text = keychain.savedUserEmail()
            passwordField.text = keychain.savedUserPassword()
        }
        updateLoginButton()
    }

    @IBAction func loginPressed(_ sender: Any) {
        login()
    }

    @IBAction func editingChanged(_ sender: Any) {
        updateLoginButton()
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }


    private func updateLoginButton() {
        guard
            let email = emailField.text,
            let pass = passwordField.text
        else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = email.isValidEmail && pass != ""
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
                self?.showAuthError(error)
                return
            }
            if let keychain = try? Container.resolve(KeychainManager.self) {
                keychain.saveUser(email: email, password: password)
            }

            guard let manager = try? Container.resolve(DataManager.self) else { return }
            manager.loginUser(user: user, completion: { (success) in
                if success {
                    self?.performSegue(withIdentifier: "loginToHome", sender: self)
                } else {
                    try? self?.auth?.signOut()
                    self?.showAuthError(nil)
                }
            })
        }
    }

    private func showAuthError(_ error: Error?) {
        let errorAlert: UIAlertController = UIAlertController(title: "An Error Occured", message: error?.localizedDescription ?? "No user found", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            errorAlert.dismiss(animated: true, completion: nil)}))
        present(errorAlert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            newField.becomeFirstResponder()
        } else {
            if loginButton.isEnabled {
                login()
            }
        }
        return true
    }
}
