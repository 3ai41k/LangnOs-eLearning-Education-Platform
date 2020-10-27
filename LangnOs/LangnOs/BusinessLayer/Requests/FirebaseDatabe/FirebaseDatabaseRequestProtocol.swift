//
//  FirebaseDatabaseRequestProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

// TO DO: Rename

protocol FirebaseDatabaseRequestProtocol {
    associatedtype Entity: Codable & CDEntityProtocol
    var entity: Entity? { get }
    var path: String { get }
    var dicationary: [String: Any]? { get }
    func setQuere(_ reference: CollectionReference) -> Query
}

extension FirebaseDatabaseRequestProtocol {
    
    var entity: Entity? { nil }
    
    var dicationary: [String: Any]? { nil }
    
    func setQuere(_ reference: CollectionReference) -> Query { reference }
    
}
