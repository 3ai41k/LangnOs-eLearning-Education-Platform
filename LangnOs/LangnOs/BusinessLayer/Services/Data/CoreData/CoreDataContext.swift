//
//  CoreDataContext.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

protocol ContextAccessableProtocol {
    var context: NSManagedObjectContext { get }
}

protocol ContextSavableProtocol {
    func saveContext()
}

final class CoreDataContext {

    // MARK: - Private properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LangnOs")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}

// MARK: - ContextAccessableProtocol

extension CoreDataContext: ContextAccessableProtocol {
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
}

// MARK: - ContextSavableProtocol

extension CoreDataContext: ContextSavableProtocol {
    
    func saveContext() {
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
    
}
