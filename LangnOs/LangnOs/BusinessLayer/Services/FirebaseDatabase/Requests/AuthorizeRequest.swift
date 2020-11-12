//
//  AuthorizeRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct AuthorizeRequest {
    
    // MARK: - Public properties
    
    let email: String
    let password: String
    
}

// MARK: - DataProviderRequestProtocol

extension AuthorizeRequest: DataProviderRequestProtocol {
    
    var collectionPath: String {
        CollectionPath.users.rawValue
    }
    
    func query(_ reference: CollectionReference) -> Query? {
        reference
            .whereField("email", isEqualTo: email)
            .whereField("password", isEqualTo: password)
    }
    
    
}
