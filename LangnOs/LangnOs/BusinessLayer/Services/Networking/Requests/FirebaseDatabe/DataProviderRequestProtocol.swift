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
    var collectionPath: CollectionPath { get }
    var query: QueryComponentProtocol? { get }
    var documentData: [String: Any]? { get }
    var documentPath: String? { get }
}

extension DataProviderRequestProtocol {
    var query: QueryComponentProtocol? { nil }
    var documentData: [String: Any]? { nil }
    var documentPath: String? { nil }
}

