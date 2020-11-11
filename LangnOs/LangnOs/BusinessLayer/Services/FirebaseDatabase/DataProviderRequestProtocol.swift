//
//  DataProviderRequestProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

protocol DataProviderRequestProtocol {
    var collectionPath: CollectionPath { get }
    var documentPath: String? { get }
    var documentData: [String: Any]? { get }
    func query(_ reference: CollectionReference) -> Query?
}

extension DataProviderRequestProtocol {
    var documentPath: String? { nil }
    var documentData: [String: Any]? { nil }
    func query(_ reference: CollectionReference) -> Query? { nil }
}

