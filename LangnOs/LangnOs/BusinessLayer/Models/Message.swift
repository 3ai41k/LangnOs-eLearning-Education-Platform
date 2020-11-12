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
    
    let userId: String
    let createdDate: Date
    let content: String
    
}
