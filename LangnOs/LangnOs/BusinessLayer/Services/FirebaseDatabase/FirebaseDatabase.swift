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
    case isNotConnectionToTheInternet
    
    var localizedDescription: String {
        switch self {
        case .documentsWereNotFound:
            return "Documents were not found".localize
        case .documentIsEmpty:
            return "Document is empty".localize
        case .isNotConnectionToTheInternet:
            return "Is not connection to the internet".localize
        }
    }
    
}

protocol FirebaseDatabaseFetchingProtocol {
    func fetch<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping ([Request.Entity]) -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseCreatingProtocol {
    func create<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseDeletingProtocol {
    func delete<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseUpdatingProtocol {
    func update<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

final class FirebaseDatabase {
    
    // MARK: - Public properties
    
    static let shared = FirebaseDatabase()
    
    // MARK: - Private properties
    
    private var dataBase: Firestore
    
    // MARK: - Init
    
    private init() {
        self.dataBase = Firestore.firestore()
    }
    
}

// MARK: - FirebaseDatabaseFetchingProtocol

extension FirebaseDatabase: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping ([Request.Entity]) -> Void, onFailure: @escaping (Error) -> Void) {
        let collectionReference = dataBase.collection(request.collectionPath.rawValue)
        let collectionReferenceWithQuery = request.query?.firebaseQuery(collectionReference) ?? collectionReference
        collectionReferenceWithQuery.getDocuments { (snapshot, error) in
            if let error = error {
                onFailure(error)
            } else {
                if let data = snapshot?.documents.map({ $0.data() }), let entities: [Request.Entity] = try? DictionaryDecoder().decode(data: data) {
                    onSuccess(entities)
                } else {
                    onSuccess([])
                }
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseCreatingProtocol

extension FirebaseDatabase: FirebaseDatabaseCreatingProtocol {
    
    func create<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let documentPath = request.documentPath else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        guard let documentData = try? DictionaryEncoder().encode(entity: request.entity) else { onFailure(FirebaseDatabaseError.documentIsEmpty); return }
        let collectionReference = dataBase.collection(request.collectionPath.rawValue)
        let documentReference = collectionReference.document(documentPath)
        documentReference.setData(documentData) { (error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseDeletingProtocol

extension FirebaseDatabase: FirebaseDatabaseDeletingProtocol {
    
    func delete<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let documentPath = request.documentPath else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        let collectionReference = dataBase.collection(request.collectionPath.rawValue)
        let documentReference = collectionReference.document(documentPath)
        documentReference.delete(completion: { (error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        })
    }
    
}

// MARK: - FirebaseDatabaseUpdatingProtocol

extension FirebaseDatabase: FirebaseDatabaseUpdatingProtocol {
    
    func update<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let documentPath = request.documentPath else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        guard let documentData = try? DictionaryEncoder().encode(entity: request.entity) else { onFailure(FirebaseDatabaseError.documentIsEmpty); return }
        let collectionReference = dataBase.collection(request.collectionPath.rawValue)
        let documentReference = collectionReference.document(documentPath)
        documentReference.updateData(documentData) { (error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
}