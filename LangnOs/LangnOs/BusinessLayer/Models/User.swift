//
//  User.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct User1: Codable {
    
    // MARK: - Public properties
    
    let id: String
    var name: String
    var email: String
    var phone: String
    var password: String
    var rights: [Right]
    
    static var empty: User1 {
        User1(id: UUID().uuidString, name: "", email: "", phone: "", password: "", rights: [
            Right(name: "isTeacher", value: false)
        ])
    }
    
}
