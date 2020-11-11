//
//  CDEntityProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

protocol CDEntityProtocol {
    associatedtype Entity
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [Entity]
    static func insert(entity: Entity, context: NSManagedObjectContext) throws
    static func update(entity: Entity, context: NSManagedObjectContext) throws
    static func delete(entity: Entity, context: NSManagedObjectContext) throws
}
