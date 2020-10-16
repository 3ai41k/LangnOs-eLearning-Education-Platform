//
//  Authorizator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth

enum AuthorizatorError: Error {
    case userCannotFound
}

protocol LoginableProtocol {
    func logOut(completion: (Error?) -> Void)
}

protocol RegistratableProtocol {
    func singInWith(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func singUpWith(name: String?, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
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

extension Authorizator: LoginableProtocol {
    
    func logOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
}

// MARK: - RegistratableProtocol

extension Authorizator: RegistratableProtocol {
    
    func singInWith(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let currentUser = self.currentUser else {
                    completion(.failure(AuthorizatorError.userCannotFound))
                    return
                }
                completion(.success(currentUser))
            }
        }
    }
    
    func singUpWith(name: String?, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let name = name {
                    self.extendedProfile(name: name, completion: completion)
                } else {
                    guard let currentUser = self.currentUser else {
                        completion(.failure(AuthorizatorError.userCannotFound))
                        return
                    }
                    completion(.success(currentUser))
                }
            }
        }
    }
    
    private func extendedProfile(name: String, completion: @escaping (Result<User, Error>) -> Void) {
        let request = currentUser?.createProfileChangeRequest()
        request?.displayName = name
        request?.commitChanges(completion: { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let currentUser = self.currentUser else {
                    completion(.failure(AuthorizatorError.userCannotFound))
                    return
                }
                completion(.success(currentUser))
            }
        })
    }
    
}
