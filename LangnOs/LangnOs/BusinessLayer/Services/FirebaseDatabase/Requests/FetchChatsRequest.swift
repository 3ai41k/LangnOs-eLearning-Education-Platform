//
//  FetchChatsRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct FetchChatsRequest { }

// MARK: - DataProviderRequestProtocol

extension FetchChatsRequest: DataProviderRequestProtocol {
    
    var collectionPath: String {
        CollectionPath.chats.rawValue
    }
    
}
