//
//  Persistence.swift
//  ExampleDataStorage
//
//  Created by Philipp on 20.05.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController(inMemory: false)
    
    //    static var preview: PersistenceController = {
    //        let result = PersistenceController(inMemory: true)
    //        let viewContext = result.container.viewContext
    //        for _ in 0..<10 {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //        }
    //        do {
    //            try viewContext.save()
    //        } catch {
    //            // Replace this implementation with code to handle the error appropriately.
    //            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //            let nsError = error as NSError
    //            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //        }
    //        return result
    //    }()
    
    static var isEmpty: Bool = {
        let viewContext = shared.container.viewContext
        do {
            let request = NSFetchRequest<Topic>(entityName: Topic.entity().name!)
            let count  = try viewContext.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = true) {
        container = NSPersistentContainer(name: "LocalData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            container.persistentStoreDescriptions.first!.url = docURL.appendingPathComponent("LocalData.sqlite")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
