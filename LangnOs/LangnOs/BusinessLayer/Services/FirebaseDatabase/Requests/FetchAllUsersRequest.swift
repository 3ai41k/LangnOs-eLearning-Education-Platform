//
//  FetchAllUsersRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct FetchAllUsersRequest { }

// MARK: - DataProviderRequestProtocol

extension FetchAllUsersRequest: DataProviderRequestProtocol {
    
    var collectionPath: CollectionPath {
        .users
    }
    
}
