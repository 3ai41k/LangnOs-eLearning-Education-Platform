//
//  UpdateUserRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 22.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct UpdateUserRequest {
    
    // MARK: - Public properties
    
    let user: User1
    
}

// MARK: - DataProviderRequestProtocol

extension UpdateUserRequest: DataProviderRequestProtocol {
    
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
