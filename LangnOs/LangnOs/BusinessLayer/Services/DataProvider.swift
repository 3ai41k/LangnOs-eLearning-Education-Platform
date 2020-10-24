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
    func fetch<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void)
}

protocol DataProviderCreatingProtocol {
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol DataProviderDeletingProtocol {
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

typealias FirebaseDatabaseProtocol = FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol & FirebaseDatabaseDeletingProtocol
typealias CoreDataContextProtocol = ContextAccessableProtocol & ContextSavableProtocol

final class DataProvider {
    
    // MARK: - Private properties
    
    private let firebaseDatabase: FirebaseDatabaseProtocol
    private let coreDataContext: CoreDataContextProtocol
    private let reachability: InternetConnectableProtocol
    
    // MARK: - Init
    
    init() {
        self.firebaseDatabase = FirebaseDatabase()
        self.coreDataContext = CoreDataContext()
        self.reachability = Reachability()
    }
    
    // MARK: - Private methods
    
    private func selectAll<Entity: CDEntityProtocol>(completion: @escaping (Result<[Entity], Error>) -> Void) {
        do {
            let entitise = try Entity.select(context: coreDataContext.context)
            completion(.success(entitise))
        } catch {
            completion(.failure(error))
        }
    }
    
}

// MARK: - DataProviderFetchingProtocol

extension DataProvider: DataProviderFetchingProtocol {
    
    func fetch<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Request.Entity], Error>) -> Void) {
        if reachability.isConnectedToNetwork {
            let context = coreDataContext.context
            firebaseDatabase.fetch(request: request) { (result: Result<[Request.Entity], Error>) in
                switch result {
                case .success(let entities):
                    entities.forEach({ try? Request.Entity.delete(context: context, entity: $0) })
                    entities.forEach({ Request.Entity.insert(context: context, entity: $0) })
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
    
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        if reachability.isConnectedToNetwork {
            guard let entity = request.entity else {
                completion(.failure(DataProviderError.entityHasNoFound))
                return
            }
            firebaseDatabase.create(request: request) { (result) in
                switch result {
                case .success:
                    Request.Entity.insert(context: self.coreDataContext.context, entity: entity)
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
    
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<Void, Error>) -> Void) {
        if reachability.isConnectedToNetwork {
            guard let entity = request.entity else {
                completion(.failure(DataProviderError.entityHasNoFound))
                return
            }
            firebaseDatabase.delete(request: request) { (result) in
                switch result {
                case .success:
                    do {
                        try Request.Entity.delete(context: self.coreDataContext.context, entity: entity)
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
