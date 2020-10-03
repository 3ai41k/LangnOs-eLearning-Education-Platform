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

protocol FirebaseDatabaseProtocol {
    func fetch<Entity: FirebaseDatabaseEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void)
}

final class FirebaseDatabase {
    
    private var dataBase: DatabaseReference {
        Database.database().reference()
    }
    
}

// MARK: - CloudFirestoreProtocol

extension FirebaseDatabase: FirebaseDatabaseProtocol {
    
    func fetch<Entity: FirebaseDatabaseEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void) {
        dataBase.child(request.collectionName).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if let documents = dataSnapshot.value as? [[String: Any]] {
                completion(.success(documents.map({ Entity(dictionary: $0) })))
            } else {
                completion(.failure(FirebaseDatabaseError.documentsWereNotFound))
            }
        }) { (error) in
            completion(.failure(error))
        }
    }
    
}
