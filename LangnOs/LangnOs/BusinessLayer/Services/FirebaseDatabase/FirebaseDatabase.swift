//
//  FirebaseDatabase.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

enum FirebaseDatabaseError: Error {
    case collectionIsEmpty
    case documentsWereNotFound
    case documentIsEmpty
    
    var localizedDescription: String {
        switch self {
        case .collectionIsEmpty:
            return "Collection is empty".localize
        case .documentsWereNotFound:
            return "Documents were not found".localize
        case .documentIsEmpty:
            return "Document is empty".localize
        }
    }
    
}

protocol FirebaseDatabaseFetchingProtocol {
    func fetch<Entity: Decodable>(request: DataProviderRequestProtocol, onSuccess: @escaping (Entity) -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseCreatingProtocol {
    func create(request: DataProviderRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseDeletingProtocol {
    func delete(request: DataProviderRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseUpdatingProtocol {
    func update(request: DataProviderRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseDatabaseListeningProtocol {
    func listen<Entity: Decodable>(request: DataProviderRequestProtocol, onSuccess: @escaping (Entity) -> Void, onFailure: @escaping (Error) -> Void)
}

typealias FirebaseDatabaseProtocol =
    FirebaseDatabaseFetchingProtocol &
    FirebaseDatabaseCreatingProtocol &
    FirebaseDatabaseDeletingProtocol &
    FirebaseDatabaseUpdatingProtocol &
    FirebaseDatabaseListeningProtocol

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
    
    func fetch<Entity: Decodable>(request: DataProviderRequestProtocol, onSuccess: @escaping (Entity) -> Void, onFailure: @escaping (Error) -> Void) {
        let collectionReference = dataBase.collection(request.collectionPath)
        let collectionReferenceWithQuery = request.query(collectionReference) ?? collectionReference
        collectionReferenceWithQuery.getDocuments { (snapshot, error) in
            if let error = error {
                onFailure(error)
            } else {
                if let data = snapshot?.documents.map({ $0.data() }), let entities: Entity = try? DictionaryDecoder().decode(data: data) {
                    onSuccess(entities)
                } else {
                    onFailure(FirebaseDatabaseError.collectionIsEmpty)
                }
            }
        }
    }
    
}

// MARK: - FirebaseDatabaseCreatingProtocol

extension FirebaseDatabase: FirebaseDatabaseCreatingProtocol {
    
    func create(request: DataProviderRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let documentPath = request.documentPath else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        guard let documentData = request.documentData else { onFailure(FirebaseDatabaseError.documentIsEmpty); return }
        let collectionReference = dataBase.collection(request.collectionPath)
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
    
    func delete(request: DataProviderRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let documentPath = request.documentPath else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        let collectionReference = dataBase.collection(request.collectionPath)
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
    
    func update(request: DataProviderRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let documentPath = request.documentPath else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        guard let documentData = request.documentData else { onFailure(FirebaseDatabaseError.documentIsEmpty); return }
        let collectionReference = dataBase.collection(request.collectionPath)
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

// MARK: - FirebaseDatabaseListeningProtocol

extension FirebaseDatabase: FirebaseDatabaseListeningProtocol {
    
    func listen<Entity: Decodable>(request: DataProviderRequestProtocol, onSuccess: @escaping (Entity) -> Void, onFailure: @escaping (Error) -> Void) {
        let collectionReference = dataBase.collection(request.collectionPath)
        let collectionReferenceWithQuery = request.query(collectionReference) ?? collectionReference
        collectionReferenceWithQuery.addSnapshotListener { (snapshot, error) in
            if let error = error {
                onFailure(error)
            } else {
                if let data = snapshot?.documents.map({ $0.data() }), let entities: Entity = try? DictionaryDecoder().decode(data: data) {
                    onSuccess(entities)
                } else {
                    onFailure(FirebaseDatabaseError.collectionIsEmpty)
                }
            }
        }
    }
    
}
