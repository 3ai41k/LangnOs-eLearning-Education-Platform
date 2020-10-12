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
    static func select(conetxt: NSManagedObjectContext) throws -> [Self]
    static func insert(conetxt: NSManagedObjectContext, entity: Self)
    static func update(conetxt: NSManagedObjectContext, entity: Self)
    static func delete(conetxt: NSManagedObjectContext, entity: Self)
}
