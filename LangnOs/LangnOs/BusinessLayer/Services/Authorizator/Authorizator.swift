//
//  Authorizator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth

protocol LoginableProtocol {
    var isUserLogin: Bool { get }
    func logOut(completion: (Error?) -> Void)
}

protocol RegistratableProtocol {
    func singInWith(email: String, password: String, completion: @escaping (Error?) -> Void)
    func singUpWith(name: String?, email: String, password: String, completion: @escaping (Error?) -> Void)
}

final class Authorizator {
    
    private var auth: Auth {
        Auth.auth()
    }
    
    private var currentUser: User? {
        auth.currentUser
    }
    
}

// MARK: - LoginableProtocol

extension Authorizator: LoginableProtocol {
    
    var isUserLogin: Bool {
        currentUser != nil
    }
    
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
    
    func singInWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            completion(error)
        }
    }
    
    func singUpWith(name: String?, email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(error)
            } else {
                let request = self.currentUser?.createProfileChangeRequest()
                request?.displayName = name
                request?.commitChanges(completion: { (error) in
                    completion(error)
                })
            }
        }
        auth.createUser(withEmail: email, password: password) { (_, error) in
            completion(error)
        }
    }
    
}
