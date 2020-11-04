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
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [Self]
    func insert(context: NSManagedObjectContext) throws
    func update(context: NSManagedObjectContext) throws
    func delete(context: NSManagedObjectContext) throws
}
