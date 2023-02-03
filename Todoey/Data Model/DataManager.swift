//
//  DataManager.swift
//  Todoey
//
//  Created by Pavel Andreev on 2/2/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
  static let shared = DataManager()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
    func category(name: String) -> Category {
        let category = Category(context: persistentContainer.viewContext)
        category.name = name
        return category
    }
    
    func item(title: String, category: Category) -> Item {
        let newItem = Item(context: persistentContainer.viewContext)
        newItem.done = false
        newItem.title = title
        newItem.parentCategory = category
        return newItem
    }
    
    func categories() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        var fetchedSingers: [Category] = []
        
        do {
            fetchedSingers = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedSingers
    }
    
    func items(category: Category) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory = %@", category)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        var fetchedSongs: [Item] = []
        do {
            fetchedSongs = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }
        return fetchedSongs
    }
    
    
  //Core Data Saving support
  func save () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
          try context.save()
      } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
    
    func deleteItem(item: Item) {
        let context = persistentContainer.viewContext
        context.delete(item)
        save()
    }
    
    func deleteCategory(category: Category) {
        let context = persistentContainer.viewContext
        context.delete(category)
        save()
    }
}
