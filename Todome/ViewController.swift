//
//  ViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 11.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        User.loginUser(withEmail: "qqqqqq5@migmail.pl", password: "qqqqqq5", completion: { (user, error) in
            if error != nil {
                showAlert(title: "Error", message: error!.localizedDescription, vc: self)
            } else {
                showAlert(title: "Success", message: "You are logged in as \(user?.email)", vc: self)
            }
        })
        */
        
//        User.logoutUser(completion: { (success) in
//            if success == true {
//                showAlert(title: "Success", message: "You are logged out.", vc: self)
//            }
//        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        User.loginUser(withEmail: "qqqqqq5@migmail.pl", password: "qqqqqq5", completion: { (user, error) in
            if error != nil {
                showAlert(title: "Error", message: error!.localizedDescription, vc: self)
            } else {
                showAlert(title: "Success", message: "You are logged in as \(user?.email)", vc: self)
            }
        })
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        User.logoutUser(completion: { (success) in
            if success == true {
                showAlert(title: "Success", message: "You are successfully logged out. Ciao!", vc: self)
            }
        })
    }
}
