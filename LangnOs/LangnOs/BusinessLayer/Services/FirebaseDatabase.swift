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
    func fetch<Entity: FDEntityProtocol, Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Entity], Error>) -> Void)
}

protocol FirebaseDatabaseCreatingProtocol {
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseDeletingProtocol {
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
}

final class FirebaseDatabase {
    
    private var dataBase: DatabaseReference {
        Database.database().reference()
    }
    
}

// MARK: - FirebaseDatabaseFetchingProtocol

extension FirebaseDatabase: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Entity: FDEntityProtocol, Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Entity], Error>) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        (request.setQuary(reference) ?? reference)?.observeSingleEvent(of: .value, with: { (dataSnapshot) in
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
    
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.setValue(request.entity?.serialize) { (error, _) in
            if let error = error {
                onError(error)
            } else {
                onSuccess()
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseDeletingProtocol

extension FirebaseDatabase: FirebaseDatabaseDeletingProtocol {
    
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.removeValue { (error, _) in
            if let error = error {
                onError(error)
            } else {
                onSuccess()
            }
        }
    }
    
}
