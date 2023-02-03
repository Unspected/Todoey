//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var index = Int()
    var category: Category?
    
//    var selectedCategory: Category?
       
    
    
    let cellID = "toDoItemCell"
    
//    init(index: Int) {
//        self.index = index
//        category = categories[index]
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let categories = category {
            itemArray = DataManager.shared.items(category: categories)
        }
        tableView.reloadData()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableViewDelegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        DataManager.shared.save()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    // MARK: - Delete Method
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .destructive, title: "") { _, _, _ in
//
//            let deleteModel = self.itemArray[indexPath.row]
//
//            self.itemArray.remove(at: indexPath.row)
//            self.tableView.reloadData()
//        }
//
//        action.backgroundColor = UIColor.red
//        action.image = UIImage(systemName: "trash")
//        return UISwipeActionsConfiguration(actions: [action])
//    }
 
    
    // MARK: - Add new item

    @IBAction func AddNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { [self] action in
            
            guard let saveText = textField.text else { return }
            
            let newItem = DataManager.shared.item(title: saveText, category: self.category!)
            
            self.itemArray.append(newItem)
            DataManager.shared.save()
            tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    // MARK: - SaveItems
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//           print("Error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
//
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        do {
//            itemArray = try context.fetch(request)
//            // используйте результаты здесь
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        tableView.reloadData()
//    }
}

//MARK: - Extension Search Bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request = NSFetchRequest<Item>(entityName: "Item")
//        guard let saveText = searchBar.text else { return }
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", saveText)
//        request.predicate = predicate
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//    }
    
    // MARK: - refresh table if remove all characters in searchbar
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
 
}
