//
//  SearchComponets.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct SearchComponets: QueryComponentProtocol {
    
    private let field: String
    private let text: String
    
    init(_ field: String, search text: String) {
        self.field = field
        self.text = text
    }
    
    func databaseQuery() -> NSPredicate {
        NSPredicate(format: "\(field) CONTAINS[cd] %@", argumentArray: [text])
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query {
        reference.order(by: field).start(at: [text]).end(at: [text + "\u{f8ff}"])
    }
    
}
