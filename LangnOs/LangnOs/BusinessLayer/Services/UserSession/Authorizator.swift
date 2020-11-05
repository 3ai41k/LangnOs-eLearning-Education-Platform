//
//  Authorizator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth

protocol LogOutableProtocol {
    func logOut(onSuccess: () -> Void, onError: (Error) -> Void)
}

protocol RegistratableProtocol {
    func singInWith(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func singUpWith(name: String, email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

final class Authorizator {
    
    // MARK: - Private properties
    
    private var auth: Auth {
        Auth.auth()
    }
    
    private var currentUser: User? {
        auth.currentUser
    }
    
}

// MARK: - LoginableProtocol

extension Authorizator: LogOutableProtocol {
    
    func logOut(onSuccess: () -> Void, onError: (Error) -> Void) {
        do {
            try auth.signOut()
            onSuccess()
        } catch {
            onError(error)
        }
    }
    
}

// MARK: - RegistratableProtocol

extension Authorizator: RegistratableProtocol {
    
    func singInWith(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
    func singUpWith(name: String, email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                onFailure(error)
            } else {
                let request = self.currentUser?.createProfileChangeRequest()
                request?.displayName = name
                request?.commitChanges(completion: { (error) in
                    if let error = error {
                        onFailure(error)
                    } else {
                        onSuccess()
                    }
                })
            }
        }
    }
    
}
