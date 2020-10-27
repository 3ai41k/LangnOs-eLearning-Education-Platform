//
//  DocumentRequestProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseFirestore

protocol DocumentRequestProtocol {
    associatedtype Entity: Codable & CDEntityProtocol
    var path: String { get }
}

protocol DocumentFethcingRequestProtocol: DocumentRequestProtocol {
    func prepareReference(_ dataBase: Firestore) -> Query
    func setQuere(_ reference: CollectionReference) -> Query
}

extension DocumentFethcingRequestProtocol {
    
    func prepareReference(_ dataBase: Firestore) -> Query {
        setQuere(dataBase.collection(path))
    }
    
    func setQuere(_ reference: CollectionReference) -> Query {
        reference
    }
    
}

protocol DocumentCreatingRequestProtocol: DocumentRequestProtocol {
    var entity: Entity { get }
    var documentData: [String: Any] { get }
    func prepareReference(_ dataBase: Firestore) -> DocumentReference
}

protocol DocumentDeletingRequestProtocol: DocumentRequestProtocol {
    var entity: Entity { get }
    func prepareReference(_ dataBase: Firestore) -> DocumentReference
}

protocol DocumentUpdatingRequestProtocol: DocumentRequestProtocol {
    var entity: Entity { get }
    var documentData: [String: Any] { get }
    func prepareReference(_ dataBase: Firestore) -> DocumentReference
}


