//
//  Message.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    // MARK: - Public properties
    
    let id: String
    let userId: String
    let createdDate: Date
    let content: String
    
    // MARK: - Init
    
    init(userId: String, content: String) {
        self.id = UUID().uuidString
        self.userId = userId
        self.createdDate = Date()
        self.content = content
    }
    
}
