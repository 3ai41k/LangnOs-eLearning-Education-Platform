//
//  CDEntityProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

enum DataBaseMode {
    case online
    case offline
    
    var isNeedToSynchronize: Bool {
        switch self {
        case .online:
            return true
        case .offline:
            return false
        }
    }
}

protocol CDEntityProtocol {
    static func select(context: NSManagedObjectContext, predicate: NSPredicate?) throws -> [Self]
    func insert(context: NSManagedObjectContext, mode: DataBaseMode) throws
    func update(context: NSManagedObjectContext, mode: DataBaseMode) throws
    func delete(context: NSManagedObjectContext, mode: DataBaseMode) throws
}
