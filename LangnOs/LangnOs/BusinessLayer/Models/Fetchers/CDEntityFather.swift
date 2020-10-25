//
//  CDEntityFather.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

enum CDEntityFatherError: Error {
    case duplicate
}

//
// Virtual class
//

class CDEntityFather<Entity> {
    func select(context: NSManagedObjectContext) throws -> [Entity] { fatalError() }
    func insert(context: NSManagedObjectContext, entity: Entity) { fatalError() }
    func update(context: NSManagedObjectContext, entity: Entity) throws { fatalError() }
    func delete(context: NSManagedObjectContext, entity: Entity) throws { fatalError() }
}
