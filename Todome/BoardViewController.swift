//
//  BoardViewController.swift
//  Todome
//
//  Created by Karol Karczewski on 14.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit
import VHUD

class BoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var projectsTableViewController: UITableView!
        
    var projects: [Project] = []
    var selectedProject: Project?
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsTableViewController.dataSource = self
        projectsTableViewController.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "⚙️", style: .plain, target: self, action: #selector(goToSettings))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        projectsTableViewController.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User.getUserInfo(completion: { (user) in
            self.currentUser = user
        })
        
        getProjectsWithLoadingAnimation()
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if self.projects.count > 0 {
            self.projectsTableViewController.separatorStyle = .singleLine
            self.projectsTableViewController.separatorColor = UIColor.white
            self.projectsTableViewController.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.projectsTableViewController.backgroundView = nil
            sections = 1
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: projectsTableViewController.bounds.size.width, height: projectsTableViewController.bounds.size.height))
            noDataLabel.text = "You have no projects yet."
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            self.projectsTableViewController.backgroundView  = noDataLabel
            self.projectsTableViewController.separatorStyle  = .none
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectsTableViewController.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectsTableViewCell
        
        cell.projectNameLabel.text = projects[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projects[indexPath.row]
        self.performSegue(withIdentifier: "showTodosInProject", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "🖊", handler: { action, indexPath in
            let alert = UIAlertController(title: "Edit", message: "Enter new name of the project:", preferredStyle: .alert)
            alert.addTextField { (editTextField) in
                editTextField.text = self.projects[indexPath.row].name
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let editTextField = alert!.textFields![0]
                if editTextField.text?.isEmpty == false && editTextField.text != self.projects[indexPath.row].name {
                    Project.editNameOfProject(project: self.projects[indexPath.row], newName: editTextField.text!)
                } else {
                }
            }))
            self.present(alert, animated: true, completion: nil)
        })
        
        let delete = UITableViewRowAction(style: .normal, title: "🗑") { action, indexPath in
            Project.deleteProject(project: self.projects[indexPath.row], completion: { (error) in
                if error != nil {
                    showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                }
            })
        }
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func getProjectsWithLoadingAnimation() {
        startLoading()
        Project.getAllProjects(completion: { (projects) in
            self.projects = projects
            stopLoading()
            self.projectsTableViewController.reloadData()
        })
    }
    
    func goToSettings() {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTodosInProject" {
            let destVC = segue.destination as! TodoViewController
            destVC.project = selectedProject
            destVC.currentUser = currentUser
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var newProjectNameTextField: UITextField!
    
    @IBAction func addProjectButtonPressed(_ sender: Any) {
        if newProjectNameTextField.text?.isEmpty == false {
            User.getUserInfo(completion: { (user) in
                Project.createNewProject(name: self.newProjectNameTextField.text!, owner: user)
                self.newProjectNameTextField.text = ""
                self.dismissKeyboard()
            })
        } else {
            showAlert(title: "Error", message: "You have to enter name of new project.", vc: self)
        }
    }
}
