//
//  QueryComponentProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

protocol QueryComponentProtocol {
    var format: String { get }
    var argument: Any { get }
    func firebaseFormat(_ reference: CollectionReference) -> Query
}
