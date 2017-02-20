//
//  Project.swift
//  Todome
//
//  Created by Karol Karczewski on 14.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Project {
    var uid: String = ""
    var name: String = ""
    var owner: User
    //var items: [String: AnyObject] = [:]
    //var itemsTest: [List]
    
    init(name: String, owner: User) {
        self.name = name
        self.owner = owner
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snap = snapshot.value as! [String:Any]
        self.uid = snapshot.key
        self.name = snap["name"] as! String
        self.owner = User.init(dict: snap["owner"] as! NSDictionary)
    }
    
    class func createNewProject(name: String, owner: User) {
        let ownerDict = User.convertToDict(data: owner)
        let payload = ["name": name , "owner": ownerDict] as [String : Any]
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("content").child(owner.uid).childByAutoId().setValue(payload)
    }
    
    class func getAllProjects(completion: @escaping ([Project]) -> Void) {
        User.getUserInfo(completion: { (user) in
            var projects = [Project]()
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).observe(.value, with: { (snapshot) in
                projects.removeAll()
                for item in snapshot.children {
                    let new = Project.init(snapshot: item as! FIRDataSnapshot)
                    projects.insert(new, at: 0)
                }
                completion(projects)
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }
    
    class func deleteProject(project: Project, completion: @escaping (Error?) -> Void) {
        User.getUserInfo(completion: { (user) in
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).child(project.uid).removeValue(completionBlock: {(error, ref) in
                completion(error)
            })
        })
    }
    
    class func editNameOfProject(project: Project, newName: String) {
        User.getUserInfo(completion: { (user) in
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).child(project.uid).child("name").setValue(newName)
        })
    }
}
