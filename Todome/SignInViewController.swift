//
//  SignInViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 14.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {
            startLoading()
            User.loginUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                } else {
                    User.checkIsUserVerified(completion: { (verified) in
                        if verified == false {
                            self.performSegue(withIdentifier: "verifyEmailAfterLogin", sender: self)
                        } else {
                            self.performSegue(withIdentifier: "showBoardAfterLogin", sender: self)
                        }
                    })
                }
                stopLoading()
            })
        } else {
            showAlert(title: "Error", message: "You haven't filled all fields yet.", vc: self)
        }
    }
    
    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) {}
}
