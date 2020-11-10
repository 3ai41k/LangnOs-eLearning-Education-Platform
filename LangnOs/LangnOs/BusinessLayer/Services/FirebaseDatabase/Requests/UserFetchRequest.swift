//
//  UserFetchRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct UserFetchRequest {
    
    // MARK: - Public properties
    
    let email: String
    let password: String
    
}

// MARK: - DataProviderRequestProtocol

extension UserFetchRequest: DataProviderRequestProtocol {
    
    typealias Entity = User1
    
    var collectionPath: CollectionPath {
        .users
    }
    
    var query: QueryComponentProtocol? {
        IsEqualToComponent("email", isEqualTo: email)
    }
    
}
