//
//  UserCreateRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct UserCreateRequest {
    
    // MARK: - Public properties
    
    let user: User1
    
}

// MARK: - DataProviderRequestProtocol

extension UserCreateRequest: DataProviderRequestProtocol {
    
    var entity: User1? {
        user
    }
    
    var collectionPath: CollectionPath {
        .users
    }
    
    var documentPath: String? {
        user.id
    }
    
}


