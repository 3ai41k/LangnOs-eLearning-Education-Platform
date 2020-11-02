//
//  DataProviderRequestProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

protocol DataProviderRequestProtocol {
    associatedtype Entity: Codable & CDEntityProtocol
    var entity: Entity? { get }
    var collectionPath: CollectionPath { get }
    var query: QueryComponentProtocol? { get }
    var documentPath: String? { get }
}

extension DataProviderRequestProtocol {
    var entity: Entity? { nil }
    var query: QueryComponentProtocol? { nil }
    var documentPath: String? { nil }
}

