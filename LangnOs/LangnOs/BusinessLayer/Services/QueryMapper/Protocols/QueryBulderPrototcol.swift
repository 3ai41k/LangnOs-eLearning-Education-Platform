//
//  QueryBulderPrototcol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

protocol QueryBulderPrototcol {
    func databaseQuery() -> NSPredicate?
    func firebaseQuery(_ reference: CollectionReference) -> Query?
}
