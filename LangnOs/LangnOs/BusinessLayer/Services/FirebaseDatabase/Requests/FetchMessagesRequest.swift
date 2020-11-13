//
//  FetchMessagesRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

struct FetchMessagesRequest {
    
    // MARK: - Public properties
    
    let chatId: String
    
}

// MARK: - DataProviderRequestProtocol

extension FetchMessagesRequest: DataProviderRequestProtocol {
    
    var collectionPath: String {
        [
            CollectionPath.chats.rawValue,
            chatId,
            CollectionPath.messages.rawValue
        ].joined(separator: "/")
    }
    
    func query(_ reference: CollectionReference) -> Query? {
        reference.order(by: "createdDate")
    }
    
}
