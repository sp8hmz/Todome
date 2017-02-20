//
//  Todo.swift
//  Todome
//
//  Created by Karol Karczewski on 15.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Todo {
    var uid: String = ""
    var content: String = ""
    var isCompleted: Bool
    
    init(uid: String, content: String, isCompleted: Bool) {
        self.content = content
        self.isCompleted = isCompleted
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snap = snapshot.value as! [String:Any]
        self.uid = snapshot.key
        self.content = snap["content"] as! String
        self.isCompleted = snap["isCompleted"] as! Bool
    }
    
    class func createNewTodo(inProject: Project, content: String,isCompleted: Bool) {
        User.getUserInfo(completion: { (user) in
            let payload = ["content": content, "isCompleted": isCompleted ] as [String : Any]
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).child(inProject.uid).child("todos").childByAutoId().setValue(payload)
        })
    }
    
    class func getAllTodos(inProject: Project, completion: @escaping ([Todo]) -> Void) {
        User.getUserInfo(completion: { (user) in
            var todos = [Todo]()
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).child(inProject.uid).child("todos").observe(.value, with: { (snapshot) in
                todos.removeAll()
                for item in snapshot.children {
                    let new = Todo.init(snapshot: item as! FIRDataSnapshot)
                    todos.insert(new, at: 0)
                }
                completion(todos)
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }
    
    class func deleteTodo(project: Project, todo: Todo, completion: @escaping (Error?) -> Void) {
        User.getUserInfo(completion: { (user) in
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).child(project.uid).child("todos").child(todo.uid).removeValue(completionBlock: {(error, ref) in
                completion(error)
            })
        })
    }
    
    class func changeStateOfTodo(project: Project, todo: Todo) {
        if todo.isCompleted == false {
            todo.isCompleted = true
        } else {
            todo.isCompleted = false
        }
        User.getUserInfo(completion: { (user) in
            let payload = ["content": todo.content, "isCompleted": todo.isCompleted ] as [String : Any]
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("content").child(user.uid).child(project.uid).child("todos").child(todo.uid).child("isCompleted").setValue(todo.isCompleted)
        })
    }
    
    class func editContent(project: Project, todo: Todo, newContent: String) {
        User.getUserInfo(completion: { (user) in
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("content").child(user.uid).child(project.uid).child("todos").child(todo.uid).child("content").setValue(newContent)
        })
    }
}
