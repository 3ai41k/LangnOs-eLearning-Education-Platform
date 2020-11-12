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
    
    var collectionPath: String {
        CollectionPath.users.rawValue
    }
    
    var documentPath: String? {
        user.id
    }
    
    var documentData: [String : Any]? {
        try? DictionaryEncoder().encode(entity: user)
    }
    
}


