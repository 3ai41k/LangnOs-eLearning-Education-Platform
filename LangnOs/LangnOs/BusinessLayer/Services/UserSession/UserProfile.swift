//
//  UserProfile.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserProfileExtandableProtocol {
    func updatePhoto(url: URL, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func removePhoto(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

final class UserProfile {
    
    // MARK: - Private properties
    
    private var auth: Auth {
        Auth.auth()
    }
    
    // MARK: - Private methods
    
    private func changeRequest(photoURL: URL?) -> UserProfileChangeRequest?  {
        let request = auth.currentUser?.createProfileChangeRequest()
        request?.photoURL = photoURL
        return request
    }
    
}

// MARK: - UserProfileExtandableProtocol

extension UserProfile: UserProfileExtandableProtocol {
    
    func updatePhoto(url: URL, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        changeRequest(photoURL: url)?.commitChanges(completion: { (error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        })
    }
    
    func removePhoto(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        changeRequest(photoURL: nil)?.commitChanges(completion: { (error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        })
    }
    
}
