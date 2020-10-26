//
//  FirebaseDatabaseRequestProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseDatabase

// TO DO: Rename

protocol FirebaseDatabaseRequestProtocol {
    associatedtype Entity: Codable & CDEntityProtocol
    var entity: Entity? { get }
    func convertEntityToDicationary() -> [String: Any]?
    func setCollectionPath(_ reference: DatabaseReference) -> DatabaseReference
    func setQuary(_ reference: DatabaseReference) -> DatabaseQuery
}

extension FirebaseDatabaseRequestProtocol {
    
    var entity: Entity? { nil }
    
    func convertEntityToDicationary() -> [String: Any]? { nil }
    
    func setQuary(_ reference: DatabaseReference) -> DatabaseQuery { reference }
    
}
