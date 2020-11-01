//
//  DataProvider.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

enum DataProviderError: Error {
    case isNotConnectedToNetwork
    case entityWasNoFound
    
    var localizedDescription: String {
        switch self {
        case .isNotConnectedToNetwork:
        return "There is no connection to the internet".localize
        case .entityWasNoFound:
            return "Entity was not found".localize
        }
    }
    
}

protocol DataProviderFetchingProtocol {
    func fetch<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping ([Request.Entity]) -> Void, onFailure: @escaping (Error) -> Void)
}

protocol DataProviderCreatingProtocol {
    func create<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol DataProviderDeletingProtocol {
    func delete<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol DataProviderUpdatingProtocol {
    func update<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

typealias FirebaseDatabaseProtocol =
    FirebaseDatabaseFetchingProtocol &
    FirebaseDatabaseCreatingProtocol &
    FirebaseDatabaseDeletingProtocol &
    FirebaseDatabaseUpdatingProtocol

final class DataProvider {
    
    // MARK: - Private properties
    
    private let firebaseDatabase: FirebaseDatabaseProtocol
    private let coreDataContext: CoreDataStack
    private let networkState: InternetConnectableProtocol
    
    // MARK: - Init
    
    init() {
        self.firebaseDatabase = FirebaseDatabase()
        self.coreDataContext = CoreDataStack.shared
        self.networkState = NetworkState.shared
    }
    
    // MARK: - Private methods
    
    private func selectEntities<Entity: CDEntityProtocol>(predicate: NSPredicate?, onSuccess: @escaping ([Entity]) -> Void, onFailure: @escaping (Error) -> Void){
        do {
            let entities = try Entity.select(context: coreDataContext.viewContext, predicate: predicate)
            onSuccess(entities)
        } catch {
            onFailure(error)
            
        }
    }
    
    private func insertEntities<Entity: CDEntityProtocol>(_ entities: [Entity], onFailure: @escaping (Error) -> Void) {
        do {
            for entity in entities {
                try Entity.insert(context: coreDataContext.viewContext, entity: entity)
            }
        } catch {
            onFailure(error)
        }
    }
    
}

// MARK: - DataProviderFetchingProtocol

extension DataProvider: DataProviderFetchingProtocol {
    
    func fetch<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping ([Request.Entity]) -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.fetch(request: request, onSuccess: { (firebaseEntities: [Request.Entity]) in
                if firebaseEntities.isEmpty {
                    onSuccess(.empty)
                } else {
                    self.insertEntities(firebaseEntities, onFailure: onFailure)
                    onSuccess(firebaseEntities)
                }
            }, onFailure: onFailure)
        } else {
            selectEntities(predicate: request.query?.databaseQuery(), onSuccess: onSuccess, onFailure: onFailure)
        }
    }
    
}

// MARK: - DataProviderCreatingProtocol

extension DataProvider: DataProviderCreatingProtocol {
    
    func create<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.create(request: request, onSuccess: { (firebaseEntity) in
                do {
                    try Request.Entity.insert(context: self.coreDataContext.viewContext, entity: firebaseEntity)
                    onSuccess()
                } catch {
                    onFailure(error)
                }
            }, onFailure: onFailure)
        } else {
            onFailure(DataProviderError.isNotConnectedToNetwork)
        }
    }
    
}

// MARK: - DataProviderDeletingProtocol

extension DataProvider: DataProviderDeletingProtocol {
    
    func delete<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.delete(request: request, onSuccess: { (firebaseEntity) in
                do {
                    try Request.Entity.delete(context: self.coreDataContext.viewContext, entity: firebaseEntity)
                    onSuccess()
                } catch {
                    onFailure(error)
                }
            }, onFailure: onFailure)
        } else {
            onFailure(DataProviderError.isNotConnectedToNetwork)
        }
    }
    
}

// MARK: - DataProviderUpdatingProtocol

extension DataProvider: DataProviderUpdatingProtocol {
    
    func update<Request: DataProviderRequestProtocol>(request: Request, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.update(request: request, onSuccess: { (firebaseEntity) in
                do {
                    try Request.Entity.update(context: self.coreDataContext.viewContext, entity: firebaseEntity)
                    onSuccess()
                } catch {
                    onFailure(error)
                }
            }, onFailure: onFailure)
        } else {
            onFailure(DataProviderError.isNotConnectedToNetwork)
        }
    }
    
}
