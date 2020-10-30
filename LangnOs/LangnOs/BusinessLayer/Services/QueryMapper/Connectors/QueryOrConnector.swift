//
//  QueryOrConnector.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct QueryOrConnector: QueryComponentProtocol {
    
    let components: [QueryComponentProtocol]
    
    func databaseQuery() -> NSPredicate {
        let predicates = components.map({ $0.databaseQuery() })
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query {
        var query: Query = reference
        components.forEach({ query = $0.firebaseQuery(reference) })
        return query
    }
    
}
