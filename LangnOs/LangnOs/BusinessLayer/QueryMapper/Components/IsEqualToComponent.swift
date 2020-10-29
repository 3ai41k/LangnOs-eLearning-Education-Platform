//
//  IsEqualToComponent.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct IsEqualToComponent: QueryComponentProtocol {
    
    let field: String
    let argument: Any
    
    init(_ field: String, isEqualTo argument: Any) {
        self.field = field
        self.argument = argument
    }
    
    var format: String {
        String(format: "%@ %@ ", field, "==")
    }
    
    func firebaseFormat(_ reference: CollectionReference) -> Query {
        reference.whereField(field, isEqualTo: argument)
    }
    
}
