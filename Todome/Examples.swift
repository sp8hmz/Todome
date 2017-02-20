//
//  Examples.swift
//  Todome
//
//  Created by Karol Karczewski on 15.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation

func projectExample() {
    
    //Creating new project
    User.getUserInfo(completion: { (user) in
        Project.createNewProject(name: "Nazwa projektu", owner: user)
    })
    
    //Fetching all projects
    Project.getAllProjects(completion: { (projects) in
        print(projects[0].name) //prints name of newest project
    })
}


func todoExample() {
    
    //Creating new todo
    User.getUserInfo(completion: { (user) in
        //Todo.createNewTodo(inProject: projects[0], content: "Visit a jungle", isCompleted: false)
    })
    
    //Fetching all projects
    //Todo.getAllTodos(inProject: projects[0], completion: { (todos) in
    //    print(todos[0].content)
    //})
    
    
}
