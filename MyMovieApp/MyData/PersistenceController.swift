//
//  MyDataManager.swift
//  MyMovieApp
//
//  Created by ali cihan on 10.12.2024.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "MyMovieApp")
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Error loading container: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("saved")
            } catch {
                // Show some error here
                print("couldnt save")
            }
        } else {
            print("no change")
        }
    }
    
    func isExist(id: Int) -> Bool {
        let fetchRequest = CDMovie.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %d", id
        )
        let context = container.viewContext
        
        if let objects = try? context.fetch(fetchRequest) {
            let isExist = objects.isEmpty ? false : true
            print(isExist)
            return isExist
        } else {
            print("error occured")
            return false
        }
    }
    
    func delete(id: Int) {
        let fetchRequest = CDMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %d", id
        )
        let context = container.viewContext
        
        if let objects = try? context.fetch(fetchRequest) {
            guard let object = objects.first else { return }
            context.delete(object)
        }
    }
}
