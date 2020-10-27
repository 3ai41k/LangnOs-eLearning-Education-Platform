//
//  FirebaseDatabase.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

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
    
    private var dataBase: Firestore {
        Firestore.firestore()
    }
    
}

// MARK: - FirebaseDatabaseFetchingProtocol

extension FirebaseDatabase: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void) {
        let reference = dataBase.collection(request.path)
        let query = request.setQuere(reference)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = snapshot?.documents.map({ $0.data() }) {
                    let entities: [Request.Entity]? = try? DictionaryDecoder().decode(data: data)
                    completion(.success(entities ?? []))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseCreatingProtocol

extension FirebaseDatabase: FirebaseDatabaseCreatingProtocol {
    
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let data = request.dicationary else {
            completion(.failure(FirebaseDatabaseError.documentIsEmpty))
            return
        }
        let reference = dataBase.collection(request.path)
        reference.addDocument(data: data) { (error) in
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
        
    }
    
}

// MARK: - FirebaseDatabaseUpdatingProtocol

extension FirebaseDatabase: FirebaseDatabaseUpdatingProtocol {
    
    func update<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
}
