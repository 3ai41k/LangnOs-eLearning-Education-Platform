//
//  CreateMessageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct CreateMessageRequest {
    
    // MARK: - Public properties
    
    let chatId: String
    let message: Message
    
}

// MARK: - DataProviderRequestProtocol

extension CreateMessageRequest: DataProviderRequestProtocol {
    
    var collectionPath: String {
        [
            CollectionPath.chats.rawValue,
            chatId,
            CollectionPath.messages.rawValue
        ].joined(separator: "/")
    }
    
    var documentPath: String? {
        message.id
    }
    
    var documentData: [String : Any]? {
        try? DictionaryEncoder().encode(entity: message)
    }
    
}
