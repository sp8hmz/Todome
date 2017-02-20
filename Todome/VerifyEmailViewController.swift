//
//  VerifyEmailViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 14.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func verifyButtonPressed(_ sender: Any) {
        startLoading()
        User.checkIsUserVerified(completion: { (verified) in
            if verified == false {
                showAlert(title: "E-mail not verified", message: "Make sure you've cliked a verification link on your e-mail.", vc: self)
            } else {
                self.performSegue(withIdentifier: "showBoardAfterVerification", sender: self)
            }
            stopLoading()
        })
    }
}
