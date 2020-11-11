//
//  UserFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct AuthorizeUserRequest {
    
    // MARK: - Public properties
    
    let email: String
    let password: String
    
}

// MARK: - DataProviderRequestProtocol

extension AuthorizeUserRequest: DataProviderRequestProtocol {
    
    var collectionPath: CollectionPath {
        .users
    }
    
    func query(_ reference: CollectionReference) -> Query? {
        reference
            .whereField("email", isEqualTo: email)
            .whereField("password", isEqualTo: password)
    }
    
    
}
