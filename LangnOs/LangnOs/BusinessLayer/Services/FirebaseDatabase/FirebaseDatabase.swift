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

final class FirebaseDatabase {
    
    private var dataBase: DatabaseReference {
        Database.database().reference()
    }
    
}

// MARK: - CloudFirestoreProtocol

extension FirebaseDatabase: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Entity: FirebaseDatabaseEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void) {
        dataBase.child(request.collectionName).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if let documents = dataSnapshot.value as? [String: Any] {
                let entities: [Entity] = documents.compactMap({ (key, value) in
                    guard let value = value as? [String: Any] else { return nil }
                    return Entity(dictionary: value)
                })
                completion(.success(entities))
            } else {
                completion(.failure(FirebaseDatabaseError.documentsWereNotFound))
            }
        }) { (error) in
            completion(.failure(error))
        }
    }
    
}

// MARK: - FirebaseDatabaseCreatingProtocol

extension FirebaseDatabase: FirebaseDatabaseCreatingProtocol {
    
    func create(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void) {
        dataBase.child(request.collectionName).childByAutoId().setValue(request.data) { (error, _) in
            completion(error)
        }
    }
    
}
