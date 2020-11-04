//
//  DataProvider.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

typealias FirebaseDatabaseProtocol =
    FirebaseDatabaseFetchingProtocol &
    FirebaseDatabaseCreatingProtocol &
    FirebaseDatabaseDeletingProtocol &
    FirebaseDatabaseUpdatingProtocol

// FirebaseDatabase Decorator

final class DataProvider {
    
    // MARK: - Private properties
    
    private let firebaseDatabase: FirebaseDatabaseProtocol
    private let coreDataContext: CoreDataStack
    private let networkState: InternetConnectableProtocol
    
    // MARK: - Init
    
    init(firebaseDatabase: FirebaseDatabaseProtocol) {
        self.firebaseDatabase = firebaseDatabase
        self.coreDataContext = CoreDataStack.shared
        self.networkState = NetworkState.shared
    }
    
}

// MARK: - FirebaseDatabaseFetchingProtocol

extension DataProvider: FirebaseDatabaseFetchingProtocol {
    
    func fetch<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping ([Request.Entity]) -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.fetch(request: request, onSuccess: { (firebaseEntities: [Request.Entity]) in
                if firebaseEntities.isEmpty {
                    onSuccess(.empty)
                } else {
                    firebaseEntities.forEach({
                        try? $0.insert(context: self.coreDataContext.viewContext)
                    })
                    onSuccess(firebaseEntities)
                }
            }, onFailure: onFailure)
        } else if let entities = try? Request.Entity.select(context: coreDataContext.viewContext, predicate: request.query?.databaseQuery()) {
            onSuccess(entities)
        }
    }
    
}

// MARK: - FirebaseDatabaseCreatingProtocol

extension DataProvider: FirebaseDatabaseCreatingProtocol {
    
    func create<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let entity = request.entity else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        if networkState.isReachable {
            firebaseDatabase.create(request: request, onSuccess: {
                try? entity.insert(context: self.coreDataContext.viewContext)
                onSuccess()
            }, onFailure: onFailure)
        } else {
            try? entity.insert(context: coreDataContext.viewContext)
            onSuccess()
        }
    }
    
}

// MARK: - FirebaseDatabaseDeletingProtocol

extension DataProvider: FirebaseDatabaseDeletingProtocol {
    
    func delete<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let entity = request.entity else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        if networkState.isReachable {
            firebaseDatabase.delete(request: request, onSuccess: {
                try? entity.delete(context: self.coreDataContext.viewContext)
                onSuccess()
            }, onFailure: onFailure)
        } else {
            // TO DO - Offline deleting
            onFailure(FirebaseDatabaseError.isNotConnectionToTheInternet)
        }
    }
    
}

// MARK: - FirebaseDatabaseUpdatingProtocol

extension DataProvider: FirebaseDatabaseUpdatingProtocol {
    
    func update<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        guard let entity = request.entity else { onFailure(FirebaseDatabaseError.documentsWereNotFound); return }
        if networkState.isReachable {
            firebaseDatabase.update(request: request, onSuccess: {
                try? entity.update(context: self.coreDataContext.viewContext)
                onSuccess()
            }, onFailure: onFailure)
        } else {
            try? entity.update(context: coreDataContext.viewContext)
            onSuccess()
        }
    }
    
}
