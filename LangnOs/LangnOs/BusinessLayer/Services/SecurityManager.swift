//
//  SecurityManager.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth

protocol UserProfileExtandableProtocol {
    func updatePhotoURL(_ url: URL, completion: @escaping (Error?) -> Void)
    func removePhotoURL(completion: @escaping (Error?) -> Void)
}

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

// MARK: - UserProfileExtandableProtocol

extension SecurityManager: UserProfileExtandableProtocol {
    
    func updatePhotoURL(_ url: URL, completion: @escaping (Error?) -> Void) {
        profileChangeRequest(photoUrl: url, completion: completion)
    }
    
    func removePhotoURL(completion: @escaping (Error?) -> Void) {
        profileChangeRequest(photoUrl: nil, completion: completion)
    }
    
    private func profileChangeRequest(photoUrl url: URL?, completion: @escaping (Error?) -> Void) {
        let request = user?.createProfileChangeRequest()
        request?.photoURL = url
        request?.commitChanges(completion: { (error) in
            completion(error)
        })
    }
    
}
