//
//  FirebaseDatabase.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum FirebaseDatabaseError: Error {
    case documentsWereNotFound
    case documentIsEmpty
    
    var localizedDescription: String {
        switch self {
        case .documentsWereNotFound:
            return "Documents were not found".localize
        case .documentIsEmpty:
            return "Document is empty".localize
        }
    }
}

protocol FirebaseDatabaseFetchingProtocol {
    func fetch<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void)
}

protocol FirebaseDatabaseCreatingProtocol {
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol FirebaseDatabaseDeletingProtocol {
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol FirebaseDatabaseUpdatingProtocol {
    func update<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

final class FirebaseDatabase {
    
    // MARK: - Private properties
    
    private var dataBase: DatabaseReference {
        Database.database().reference()
    }
    
    // MARK: - Private methods
    
    private func decode<Entity: Decodable>(dicationary: [String: Any], onError: (Error) -> Void) -> [Entity] {
        do {
            let entities: [String: Entity] = try DictionaryDecoder().decode(dictionary: dicationary)
            return Array(entities.values)
        } catch {
            onError(error)
        }
        return []
    }
    
}

// MARK: - FirebaseDatabaseFetchingProtocol

extension FirebaseDatabase: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        (request.setQuary(reference) ?? reference)?.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if let documents = dataSnapshot.value as? [String: [String: Any]] {
                let entities: [Request.Entity] = self.decode(dicationary: documents, onError: { completion(.failure($0)) })
                completion(.success(entities))
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
    
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dicationary = request.convertEntityToDicationary(), !dicationary.isEmpty else {
            completion(.failure(FirebaseDatabaseError.documentIsEmpty))
            return
        }
        
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.setValue(dicationary) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseDeletingProtocol

extension FirebaseDatabase: FirebaseDatabaseDeletingProtocol {
    
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.removeValue { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseUpdatingProtocol

extension FirebaseDatabase: FirebaseDatabaseUpdatingProtocol {
    
    func update<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let dicationary = request.convertEntityToDicationary(), !dicationary.isEmpty else {
            completion(.failure(FirebaseDatabaseError.documentIsEmpty))
            return
        }
        
        var reference = dataBase
        reference = request.setCollectionPath(reference)
        reference.updateChildValues(dicationary) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
