//
//  SignUpViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 14.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if nameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {
            startLoading()
            User.registerNewUser(withEmail: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, completion: { (user, error) in
                if error != nil {
                    showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                } else {
                    User.loginUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                        if error != nil {
                            showAlert(title: "Error", message: "Account is created, but an error occured while logging in.", vc: self)
                        } else {
                            self.performSegue(withIdentifier: "verifyEmail", sender: self)
                        }
                    })
                }
                stopLoading()
            })
        } else {
            showAlert(title: "Error", message: "You haven't filled all fields yet.", vc: self)
        }
    }
}
