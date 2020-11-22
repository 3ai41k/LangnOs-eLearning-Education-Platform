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
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, password, photoURL, rights
    }
    
    let id: String
    var name: String
    var email: String
    var phone: String
    var password: String
    @Published var photoURL: URL?
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        password = try container.decode(String.self, forKey: .password)
        photoURL = try container.decode(URL.self, forKey: .photoURL)
        rights = try container.decode([Right].self, forKey: .rights)
    }
    
    // MARK: - Public methods
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(password, forKey: .password)
        try container.encode(photoURL, forKey: .photoURL)
        try container.encode(rights, forKey: .rights)
    }
    
}
