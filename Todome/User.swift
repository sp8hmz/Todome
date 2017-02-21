//
//  User.swift
//  Todome
//
//  Created by Karol Karczewski on 11.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class User {
    var name: String = ""
    var email: String = ""
    var uid: String = ""
    
    init(name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid
    }
    
    init(dict: NSDictionary) {
        self.name = dict.value(forKey: "name") as! String
        self.email = dict.value(forKey: "email") as! String
        self.uid = dict.value(forKey: "uid") as! String
    }
    
    class func convertToDict(data: User) -> NSDictionary {
        return ["name": data.name, "email": data.email, "uid": data.uid]
    }
    
    class func registerNewUser(withEmail: String, password: String, name: String, completion: @escaping (FIRUser?, Error?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password) { (user, error) in
            if error == nil {
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: nil)
                
                let email = user?.email
                let uid = user?.uid
                let payload = ["email": email, "name": name]
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("users").child(uid!).setValue(payload)
            }
            completion(user, error)
        }
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (FIRUser?, Error?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    class func logoutUser(completion: @escaping (Bool?) -> Void) {
        let stateBefore = FIRAuth.auth()?.currentUser
        try! FIRAuth.auth()?.signOut()
        let stateAfter = FIRAuth.auth()?.currentUser
        if stateBefore != stateAfter && stateAfter == nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    class func checkIsUserVerified(completion: @escaping (Bool?) -> Void) {
        if let user = FIRAuth.auth()?.currentUser {
            user.reload(completion: { (error) in
                if error == nil {
                    if user.isEmailVerified == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            })
        }
    }
    
    class func checkIsUserLoggedIn(completion: @escaping (Bool?) -> Void) {
        if let _ = FIRAuth.auth()?.currentUser {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    class func getUserInfo(completion: @escaping (User) -> Void) {
        if let user = FIRAuth.auth()?.currentUser {
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let userID = user.uid
            ref.child("users/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let result = User.init(name: name, email: user.email!, uid: user.uid)
                completion(result)
            })
        }
    }
    
    class func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            completion(error)
        })
    }
    
    class func deleteUser() {
        
    }
    
    class func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        FIRAuth.auth()?.currentUser?.updatePassword(newPassword) { (error) in
            completion(error)
        }
    }
    
    class func reauthenticate(password: String, completion: @escaping (Error?) -> Void) {
        if let user = FIRAuth.auth()?.currentUser {
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: user.email!, password: password)
            
            user.reauthenticate(with: credential) { (error) in
                completion(error)
            }
        }
    }
}
