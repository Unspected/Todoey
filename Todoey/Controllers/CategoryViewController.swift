//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pavel Andreev on 2/1/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

var categories = [Category]()

class CategoryViewController: UITableViewController {
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let cellID = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        categories = DataManager.shared.categories()
        
    }
    
    //MARK: - New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { action in
            
            guard let saveTextField = textField.text else { return}
            let newCategory = DataManager.shared.category(name: saveTextField)
            
            categories.append(newCategory)
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
    
    //MARK: - tableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //MARK: - tableView Delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            destionationVC.category = categories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editSingerAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteSingerAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    
    // MARK: - Manipulation Functions
    private func editSingerAction(indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var nameTextField = UITextField()

        let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            guard let saveText = nameTextField.text else { return }
            category.setValue(saveText, forKey: "name")
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            alertTextField.text = category.name
            nameTextField = alertTextField
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteSingerAction(indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this Category?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            DataManager.shared.deleteCategory(category: category)
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
            //do nothing
        }
        areYouSureAlert.addAction(noDeleteAction)
        areYouSureAlert.addAction(yesDeleteAction)
        self.present(areYouSureAlert, animated: true, completion: nil)
    }
}
    
