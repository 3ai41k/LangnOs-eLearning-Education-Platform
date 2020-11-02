//
//  CoreDataStack.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataSavableProtocol {
    func save()
}

protocol CoreDataClearableProtocol {
    func clear()
}

protocol CoreDataSynchronizableProtocol {
    func synchronizableEntities() -> [NSEntityDescription]
}

final class CoreDataStack {

    // MARK: - Public properties
    
    static let shared = CoreDataStack()
    
    lazy var viewContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LangnOs")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Private methods

    private func clearDeepObjectEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try viewContext.execute(deleteRequest)
            save()
        } catch {
            fatalError("Unresolved error \(error.localizedDescription)")
        }
    }
    
}

// MARK: - CoreDataSavableProtocol

extension CoreDataStack: CoreDataSavableProtocol {
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK: - CoreDataClearableProtocol

extension CoreDataStack: CoreDataClearableProtocol {
    
    func clear() {
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }
    
}

// MARK: - CoreDataSynchronizableProtocol

extension CoreDataStack: CoreDataSynchronizableProtocol {
    
    func synchronizableEntities() -> [NSEntityDescription] {
        let entities = persistentContainer.managedObjectModel.entities
        return entities.compactMap({
            if $0.properties.contains(where: { $0.name == "isSynchronized" }) {
                return $0
            } else {
                return nil
            }
        })
    }
    
}
