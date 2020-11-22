//
//  User.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

class User1: Codable {
    
    // MARK: - Public properties
    
    let id: String
    var name: String
    var email: String
    var phone: String
    var password: String
    var photoURL: URL?
    var rights: [Right]
    
    static var empty: User1 {
        User1(id: UUID().uuidString, name: "", email: "", phone: "", password: "", photoURL: nil, rights: [
            Right(name: "isTeacher", value: false)
        ])
    }
    
    // MARK: - Init
    
    private init(id: String, name: String, email: String, phone: String, password: String, photoURL: URL?, rights: [Right]) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
        self.photoURL = photoURL
        self.rights = rights
    }
    
}
