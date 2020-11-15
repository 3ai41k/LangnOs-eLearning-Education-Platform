//
//  DeleteChatRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 15.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct DeleteChatRequest {
    
    // MARK: - Public properties
    
    let chat: Chat
    
}

// MARK: - DataProviderRequestProtocol

extension DeleteChatRequest: DataProviderRequestProtocol {
    
    var collectionPath: String {
        CollectionPath.chats.rawValue
    }
    
    var documentPath: String? {
        chat.id
    }
    
}
