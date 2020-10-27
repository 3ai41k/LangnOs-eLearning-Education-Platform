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
    private let network: InternetConnectableProtocol
    
    // MARK: - Init
    
    init() {
        self.firebaseDatabase = FirebaseDatabase()
        self.coreDataContext = CoreDataContext.shared
        self.network = NetworkState.shared
    }
    
    // MARK: - Private methods
    
    private func selectAll<Entity: CDEntityProtocol>(completion: @escaping (Result<[Entity], Error>) -> Void) {
        do {
            let entitise = try Entity.select(context: coreDataContext.persistentContainer.viewContext)
            completion(.success(entitise))
        } catch {
            completion(.failure(error))
        }
    }
    
}

// MARK: - DataProviderFetchingProtocol

extension DataProvider: DataProviderFetchingProtocol {
    
    func fetch<Request: DocumentFethcingRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void) {
        if network.isReachable {
            firebaseDatabase.fetch(request: request) { (result: Result<[Request.Entity], Error>) in
                switch result {
                case .success(let entities):
                    entities.forEach({ try? Request.Entity.delete(context: self.coreDataContext.viewContext, entity: $0) })
                    entities.forEach({ Request.Entity.insert(context: self.coreDataContext.viewContext, entity: $0) })
                    self.selectAll(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            selectAll(completion: completion)
        }
    }
    
}

// MARK: - DataProviderCreatingProtocol

extension DataProvider: DataProviderCreatingProtocol {
    
    func create<Request: DocumentCreatingRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        if network.isReachable {
            firebaseDatabase.create(request: request) { (result) in
                switch result {
                case .success:
                    Request.Entity.insert(context: self.coreDataContext.viewContext, entity: request.entity)
                    completion(.success(()))
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
        if network.isReachable {
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
        if network.isReachable {
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
