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
//        let itemVC = ToDoListViewController(index: indexPath.row)
        
//        performSegue(withIdentifier: "goToItems", sender: self)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! ToDoListViewController

        if let indexPath = self.tableView.indexPathForSelectedRow {
            destionationVC.category = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulations Methods
    
//    func saveCategories() {
//        do {
//            try context.save()
//        } catch {
//           print("Error saving Categories \(error)")
//        }
//        
//        self.tableView.reloadData()
//    }
//    func loadCategories() {
//  //      let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//            // используйте результаты здесь
//        } catch let error as NSError {
//            print("Error loading categories \(error)")
//        }
//        tableView.reloadData()
//    }

}
