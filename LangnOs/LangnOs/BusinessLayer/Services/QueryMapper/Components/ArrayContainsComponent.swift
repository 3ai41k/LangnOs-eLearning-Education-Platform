//
//  ContainsInComponent.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 31.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct ArrayContainsComponent: QueryComponentProtocol {
    
    private let field: String
    private let argument: Any
    
    init(_ field: String, contains argument: Any) {
        self.field = field
        self.argument = argument
    }
    
    func databaseQuery() -> NSPredicate {
        NSPredicate(format: "\(field) == %@", argumentArray: [argument])
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query {
        reference.whereField(field, arrayContainsAny: [argument])
    }
    
    
}
