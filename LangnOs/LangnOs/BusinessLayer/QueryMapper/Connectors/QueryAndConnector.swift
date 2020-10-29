//
//  QueryAndConnector.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct QueryAndConnector: QueryConnectorProtocol {
    
    let componets: [QueryComponentProtocol]
    
    func databaseFormat() -> String {
        componets.map({ $0.format + "%@" }).joined(separator: " AND ")
    }
    
    func databaseArguments() -> [Any] {
        componets.map({ $0.argument })
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query {
        var query: Query = reference
        for componet in componets {
            query = componet.firebaseFormat(reference)
        }
        return query
    }
    
}
