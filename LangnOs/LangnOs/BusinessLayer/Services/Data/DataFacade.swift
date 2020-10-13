//
//  DataFacade.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

// TO DO: Rename

enum DataFacadeError: Error {
    case isNotConnectedToNetwork
}

protocol DataFacadeFetchingProtocol {
    func fetch<Entity: FDEntityProtocol & CDEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void)
}

protocol DataFacadeCreatingProtocol {
    func create(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void)
}

protocol DataFacadeDeletingProtocol {
    func delete(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void)
}

typealias FirebaseDatabaseProtocol = FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol & FirebaseDatabaseDeletingProtocol
typealias CoreDataContextProtocol = ContextAccessableProtocol & ContextSavableProtocol

final class DataFacade {
    
    // MARK: - Private properties
    
    private let firebaseDatabase: FirebaseDatabaseProtocol
    private let coreDataContext: CoreDataContextProtocol
    private let reachability: InternetConnectableProtocol
    
    // MARK: - Init
    
    init(firebaseDatabase: FirebaseDatabaseProtocol,
         coreDataContext: CoreDataContextProtocol,
         reachability: InternetConnectableProtocol) {
        self.firebaseDatabase = firebaseDatabase
        self.coreDataContext = coreDataContext
        self.reachability = reachability
    }
    
    // MARK: - Private methods
    
    private func saveEntities<Entity: CDEntityProtocol>(_ entities: [Entity]) {
        entities.forEach({ Entity.insert(context: coreDataContext.context, entity: $0) })
        coreDataContext.saveContext()
    }
    
    private func tryToSelectEntities<Entity: CDEntityProtocol>(completion: @escaping (Result<[Entity], Error>) -> Void) {
        do {
            let coreDataEntities = try Entity.select(context: coreDataContext.context)
            completion(.success(coreDataEntities))
        } catch {
            completion(.failure(error))
        }
    }
    
}

// MARK: - DataFacadeFetchingProtocol

extension DataFacade: DataFacadeFetchingProtocol {
    
    func fetch<Entity: FDEntityProtocol & CDEntityProtocol>(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Result<[Entity], Error>) -> Void) {
        if reachability.isConnectedToNetwork {
            firebaseDatabase.fetch(request: request) { (result: Result<[Entity], Error>) in
                switch result {
                case .success(let entities):
                    do {
                        try Entity.delete(context: self.coreDataContext.context)
                        self.saveEntities(entities)
                        completion(.success(entities))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            tryToSelectEntities(completion: completion)
        }
    }
    
}

// MARK: - DataFacadeCreatingProtocol

extension DataFacade: DataFacadeCreatingProtocol {
    
    func create(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void) {
        if reachability.isConnectedToNetwork {
            firebaseDatabase.create(request: request, completion: completion)
        } else {
            completion(DataFacadeError.isNotConnectedToNetwork)
        }
    }
    
}

// MARK: - DataFacadeDeletingProtocol

extension DataFacade: DataFacadeDeletingProtocol {
    
    func delete(request: FirebaseDatabaseRequestProtocol, completion: @escaping (Error?) -> Void) {
        if reachability.isConnectedToNetwork {
            firebaseDatabase.delete(request: request, completion: completion)
        } else {
            completion(DataFacadeError.isNotConnectedToNetwork)
        }
    }
    
}
