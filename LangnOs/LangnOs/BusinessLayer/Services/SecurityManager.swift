//
//  SecurityManager.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth

final class SecurityManager {
    
    // MARK: - Public properties
    
    static let shared = SecurityManager()
    
    private(set) var user: User?
    
    // MARK: - Init
    
    private init() {
        self.user = Auth.auth().currentUser
    }
    
    // MARK: - Public methods
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func removeUser() {
        self.user = nil
    }
    
}
