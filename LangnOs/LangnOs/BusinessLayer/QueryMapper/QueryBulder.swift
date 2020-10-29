//
//  QueryBulder.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct QueryBulder: QueryBulderPrototcol {
    
    let connectors: [QueryConnectorProtocol]
    
    func databaseQuery() -> NSPredicate? {
        guard connectors.isEmpty else { return nil }
        let format = connectors.map({ $0.databaseFormat() }).joined()
        let arguments = connectors.map({ $0.databaseArguments() })
        return NSPredicate(format: format, argumentArray: arguments)
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query? {
        guard connectors.isEmpty else { return nil }
        var query: Query = reference
        for connector in connectors {
            query = connector.firebaseQuery(reference)
        }
        return query
    }
    
}
