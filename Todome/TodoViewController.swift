//
//  TodoViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 15.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var todoNavigationItem: UINavigationItem!
    
    var currentUser: User?
    var project: Project?
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.tableFooterView = UIView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTodosWithLoadingAnimation()
        todoNavigationItem.title = project?.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if self.todos.count > 0 {
            self.todoTableView.separatorStyle = .singleLine
            self.todoTableView.separatorColor = UIColor.darkGray
            self.todoTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.todoTableView.backgroundView = nil
            sections = 1
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: todoTableView.bounds.size.width, height: todoTableView.bounds.size.height))
            noDataLabel.text = "You have no todos here"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            self.todoTableView.backgroundView  = noDataLabel
            self.todoTableView.separatorStyle  = .none
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        cell.todoContentLabel.text = self.todos[indexPath.row].content
        if self.todos[indexPath.row].isCompleted == true {
            cell.todoContentLabel.textColor = UIColor.gray
        } else {
            cell.todoContentLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "🖊", handler: { action, indexPath in
            let alert = UIAlertController(title: "Edit", message: "Enter new name of the project:", preferredStyle: .alert)
            alert.addTextField { (editTextField) in
                editTextField.text = self.todos[indexPath.row].content
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let editTextField = alert!.textFields![0]
                if editTextField.text?.isEmpty == false && editTextField.text != self.todos[indexPath.row].content {
                    Todo.editContent(project: self.project!, todo: self.todos[indexPath.row], newContent: editTextField.text!)
                } else {
                }
            }))
            self.present(alert, animated: true, completion: nil)
        })

        
        let changeState = UITableViewRowAction(style: .normal, title: "✅/❎") { action, index in
            Todo.changeStateOfTodo(project: self.project!, todo: self.todos[editActionsForRowAt.row])
        }
        changeState.backgroundColor = .lightGray
        
        let delete = UITableViewRowAction(style: .normal, title: "🗑") { action, index in
            Todo.deleteTodo(project: self.project!, todo: self.todos[editActionsForRowAt.row], completion: { (error) in
                if error != nil {
                    showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                }
            })
        }
        delete.backgroundColor = .red
        
        return [delete, changeState, edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func getTodosWithLoadingAnimation() {
        startLoading()
        Todo.getAllTodos(inProject: project!, completion: { (todos) in
            self.todos.removeAll()
            self.todoTableView.reloadData()
            self.todos = todos
            stopLoading()
            self.todoTableView.reloadData()
        })
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBOutlet weak var newTaskContentTextField: UITextField!
    @IBAction func addNewTaskButtonPressed(_ sender: Any) {
        if newTaskContentTextField.text?.isEmpty == false {
            User.getUserInfo(completion: { (user) in
                Todo.createNewTodo(inProject: self.project!, content: self.newTaskContentTextField.text!, isCompleted: false)
                self.newTaskContentTextField.text = ""
                self.dismissKeyboard()
                })
        } else {
            showAlert(title: "Error", message: "You have to enter your task first.", vc: self)
        }
    }
    
}
