//
//  DataProvider.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

enum DataProviderError: Error {
    case isNotConnectedToNetwork
    case entityHasNoFound
}

protocol DataProviderFetchingProtocol {
    func fetch<Request: DocumentFethcingRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void)
}

protocol DataProviderCreatingProtocol {
    func create<Request: DocumentCreatingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol DataProviderDeletingProtocol {
    func delete<Request: DocumentDeletingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol DataProviderUpdatingProtocol {
    func update<Request: DocumentUpdatingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

typealias FirebaseDatabaseProtocol =
    FirebaseDatabaseFetchingProtocol &
    FirebaseDatabaseCreatingProtocol &
    FirebaseDatabaseDeletingProtocol &
    FirebaseDatabaseUpdatingProtocol

final class DataProvider {
    
    // MARK: - Private properties
    
    private let firebaseDatabase: FirebaseDatabaseProtocol
    private let coreDataContext: CoreDataContext
    private let networkState: InternetConnectableProtocol
    
    // MARK: - Init
    
    init() {
        self.firebaseDatabase = FirebaseDatabase()
        self.coreDataContext = CoreDataContext.shared
        self.networkState = NetworkState.shared
    }
    
}

// MARK: - DataProviderFetchingProtocol

extension DataProvider: DataProviderFetchingProtocol {
    
    func fetch<Request: DocumentFethcingRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.fetch(request: request) { (result: Result<[Request.Entity], Error>) in
                switch result {
                case .success(let firebaseEntities):
                    do {
                        for firebaseEntity in firebaseEntities {
                            try Request.Entity.insert(context: self.coreDataContext.viewContext, entity: firebaseEntity)
                        }
                        let databaseEntities = try Request.Entity.select(context: self.coreDataContext.viewContext, predicate: request.predicate)
                        completion(.success(databaseEntities))
                    } catch {
                         completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            do {
                let entities = try Request.Entity.select(context: self.coreDataContext.viewContext, predicate: request.predicate)
                completion(.success(entities))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

// MARK: - DataProviderCreatingProtocol

extension DataProvider: DataProviderCreatingProtocol {
    
    func create<Request: DocumentCreatingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.create(request: request) { (result) in
                switch result {
                case .success:
                    do {
                        try Request.Entity.insert(context: self.coreDataContext.viewContext, entity: request.entity)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(DataProviderError.isNotConnectedToNetwork))
        }
    }
    
}

// MARK: - DataProviderDeletingProtocol

extension DataProvider: DataProviderDeletingProtocol {
    
    func delete<Request: DocumentDeletingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.delete(request: request) { (result) in
                switch result {
                case .success:
                    do {
                        try Request.Entity.delete(context: self.coreDataContext.viewContext, entity: request.entity)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(DataProviderError.isNotConnectedToNetwork))
        }
    }
    
}

// MARK: - DataProviderUpdatingProtocol

extension DataProvider: DataProviderUpdatingProtocol {
    
    func update<Request: DocumentUpdatingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        if networkState.isReachable {
            firebaseDatabase.update(request: request) { (result) in
                switch result {
                case .success:
                    do {
                        try Request.Entity.update(context: self.coreDataContext.viewContext, entity: request.entity)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(DataProviderError.isNotConnectedToNetwork))
        }
    }
    
}
