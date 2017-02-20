//
//  SettingsViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 16.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
