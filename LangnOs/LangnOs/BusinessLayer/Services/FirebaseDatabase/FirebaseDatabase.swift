//
//  FirebaseDatabase.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseDatabase

enum FirebaseDatabaseError: Error {
    case documentsWereNotFound
}

protocol FirebaseDatabaseFetchingProtocol {
    func fetch<Entity: FirebaseDatabaseEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void)
}

protocol FirebaseDatabaseCreatingProtocol {
    func create(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void)
}

protocol FirebaseDatabaseDeletingProtocol {
    func delete(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void)
}

final class FirebaseDatabase {
    
    private var dataBase: DatabaseReference {
        Database.database().reference()
    }
    
}

// MARK: - CloudFirestoreProtocol

extension FirebaseDatabase: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Entity: FirebaseDatabaseEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        request.setQuary(reference)?.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if let documents = dataSnapshot.value as? [String: [String: Any]] {
                completion(.success(documents.map({ Entity(dictionary: $1) })))
            } else {
                completion(.success([]))
            }
        }) { (error) in
            completion(.failure(error))
        }
    }
    
}

// MARK: - FirebaseDatabaseCreatingProtocol

extension FirebaseDatabase: FirebaseDatabaseCreatingProtocol {
    
    func create(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.setValue(request.data) { (error, _) in
            completion(error)
        }
    }
    
}

// MARK: - FirebaseDatabaseDeletingProtocol

extension FirebaseDatabase: FirebaseDatabaseDeletingProtocol {
    
    func delete(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.removeValue { (error, _) in
            completion(error)
        }
    }
    
}
