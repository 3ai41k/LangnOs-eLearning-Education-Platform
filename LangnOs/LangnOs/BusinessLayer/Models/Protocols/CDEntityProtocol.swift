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
    static func select(context: NSManagedObjectContext) throws -> [Self]
    func insert(context: NSManagedObjectContext)
    func update(context: NSManagedObjectContext)
    func delete(context: NSManagedObjectContext) throws
}
