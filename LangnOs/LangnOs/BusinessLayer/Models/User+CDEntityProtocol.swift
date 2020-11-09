//
//  User+CDEntityProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

extension User1: CDEntityProtocol {
    
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [User1] {
        []
    }
    
    func insert(context: NSManagedObjectContext) throws {
        
    }
    
    func update(context: NSManagedObjectContext) throws {
        
    }
    
    func delete(context: NSManagedObjectContext) throws {
        
    }
    
}
