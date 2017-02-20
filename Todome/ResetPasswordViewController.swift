//
//  ResetPasswordViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 14.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        if emailTextField.text?.isEmpty == false {
            User.sendPasswordReset(email: emailTextField.text!, completion: { (error) in
                if error != nil {
                    showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                } else {
                    self.performSegue(withIdentifier: "signInAfterReset", sender: self)
                }
            })
        } else {
            showAlert(title: "Error", message: "You have to give your e-mail.", vc: self)
        }
    }
}
