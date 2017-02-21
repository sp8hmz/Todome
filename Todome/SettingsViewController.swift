//
//  SettingsViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 16.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User.getUserInfo(completion: { (user) in
            self.userNameLabel.text = user.name
            self.userEmailLabel.text = user.email
        })
    }

    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        let changePasswordAlert = UIAlertController(title: "Change password", message: "Enter actual password:", preferredStyle: .alert)
        changePasswordAlert.addTextField { (actualPasswordTextField) in
            actualPasswordTextField.isSecureTextEntry = true
            actualPasswordTextField.placeholder = "actual password"
        }
        changePasswordAlert.addTextField { (newPasswordTextField) in
            newPasswordTextField.isSecureTextEntry = true
            newPasswordTextField.placeholder = "new password"
        }
        changePasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak changePasswordAlert] (_) in
            let actualPasswordTextField = changePasswordAlert!.textFields![0]
            let newPasswordTextField = changePasswordAlert!.textFields![1]
            if actualPasswordTextField.text?.isEmpty == false && newPasswordTextField.text?.isEmpty == false && actualPasswordTextField.text != newPasswordTextField.text {
                User.reauthenticate(password: actualPasswordTextField.text!, completion: { (error) in
                    if error != nil {
                        showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                    } else {
                        User.changePassword(newPassword: newPasswordTextField.text!, completion: { (error) in
                            if error != nil {
                                showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                            } else {
                                User.logoutUser(completion: { (success) in
                                    if success == true {
                                        self.performSegue(withIdentifier: "goToSignIn", sender: self)
                                    } else {
                                        showAlert(title: "Error", message: "An error occured while trying to log out.", vc: self)
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }))
        self.present(changePasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        User.logoutUser(completion: { (success) in
            if success == true {
                self.performSegue(withIdentifier: "goToSignIn", sender: self)
            } else {
                showAlert(title: "Error", message: "An error occured while trying to log out.", vc: self)
            }
        })
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
    }
}
