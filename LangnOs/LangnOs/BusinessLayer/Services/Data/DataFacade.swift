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
    case entityHasNoFound
}

protocol DataFacadeFetchingProtocol {
    func fetch<Entity: FDEntityProtocol & CDEntityProtocol, Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Entity], Error>) -> Void)
}

protocol DataFacadeCreatingProtocol {
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Error?) -> Void)
}

protocol DataFacadeDeletingProtocol {
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Error?) -> Void)
}

typealias FirebaseDatabaseProtocol = FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol & FirebaseDatabaseDeletingProtocol
typealias CoreDataContextProtocol = ContextAccessableProtocol & ContextSavableProtocol

final class DataFacade {
    
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
    
    private func tryToSelectEntities<Entity: CDEntityProtocol>() -> [Entity] {
        do {
            return try Entity.select(context: coreDataContext.context)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    private func saveEntities<Entity: CDEntityProtocol>(_ entities: [Entity]) {
        entities.forEach({ $0.insert(context: coreDataContext.context) })
        coreDataContext.save()
    }
    
    private func deleteAllEntities<Entity: CDEntityProtocol>(_ entities: [Entity]) {
        for entity in entities {
            tryToDeleteAnEntity(entity)
        }
    }
    
    private func tryToDeleteAnEntity<Entity: CDEntityProtocol>(_ entity: Entity) {
        do {
            try entity.delete(context: coreDataContext.context)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - DataFacadeFetchingProtocol

extension DataFacade: DataFacadeFetchingProtocol {
    
    func fetch<Entity: FDEntityProtocol & CDEntityProtocol, Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Result<[Entity], Error>) -> Void) {
        if reachability.isConnectedToNetwork {
            firebaseDatabase.fetch(request: request) { (result: Result<[Entity], Error>) in
                switch result {
                case .success(let entities):
                    self.deleteAllEntities(entities)
                    self.saveEntities(entities)
                    completion(.success(entities))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let localEntities: [Entity] = tryToSelectEntities()
            completion(.success(localEntities))
        }
    }
    
}

// MARK: - DataFacadeCreatingProtocol

extension DataFacade: DataFacadeCreatingProtocol {
    
    func create<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Error?) -> Void) {
        if reachability.isConnectedToNetwork {
            firebaseDatabase.create(request: request, onSuccess: {
                request.entity?.insert(context: self.coreDataContext.context)
                completion(nil)
            }) { (error) in
                completion(error)
            }
        } else {
            completion(DataFacadeError.isNotConnectedToNetwork)
        }
    }
    
}

// MARK: - DataFacadeDeletingProtocol

extension DataFacade: DataFacadeDeletingProtocol {
    
    func delete<Request: FirebaseDatabaseRequestProtocol>(request: Request, completion: @escaping (Error?) -> Void) {
        if reachability.isConnectedToNetwork {
            firebaseDatabase.delete(request: request, onSuccess: {
                do {
                    try request.entity?.delete(context: self.coreDataContext.context)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }) { (error) in
                completion(error)
            }
        } else {
            completion(DataFacadeError.isNotConnectedToNetwork)
        }
    }
    
}
