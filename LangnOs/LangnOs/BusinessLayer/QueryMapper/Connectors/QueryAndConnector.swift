//
//  QueryAndConnector.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct QueryAndConnector: QueryBulderPrototcol {
    
    let componets: [QueryComponentProtocol]
    
    func databaseQuery() -> NSPredicate? {
        guard !componets.isEmpty else { return nil }
        let format = componets.map({ $0.format + "%@" }).joined(separator: " AND ")
        let argumets = componets.map({ $0.argument })
        return NSPredicate(format: format, argumentArray: argumets)
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query? {
        guard !componets.isEmpty else { return nil }
        var query: Query = reference
        for componet in componets {
            query = componet.firebaseFormat(reference)
        }
        return query
    }
    
}
