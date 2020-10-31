//
//  IsEqualToComponent.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct IsEqualToComponent: QueryComponentProtocol {
    
    private let field: String
    private let argument: Any
    
    init(_ field: String, isEqualTo argument: Any) {
        self.field = field
        self.argument = argument
    }
    
    func databaseQuery() -> NSPredicate {
        NSPredicate(format: "userId == %@", argumentArray: [argument])
    }
    
    func firebaseQuery(_ reference: CollectionReference) -> Query {
        reference.whereField(field, isEqualTo: argument)
    }
    
}
