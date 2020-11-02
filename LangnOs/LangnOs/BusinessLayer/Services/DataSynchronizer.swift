//
//  DataSynchronizer.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData
import Reachability
import Combine

class SyncronizeOperation: Operation {
    
    let firebaseDatabase: FirebaseDatabase
    
    override init() {
        self.firebaseDatabase = FirebaseDatabase()
        
        super.init()
    }
    
    override func main() {
        syncronize()
    }
    
    func syncronize() {
        
    }
    
}

final class VocabularySyncronizeOperation: SyncronizeOperation {
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
        
        super.init()
    }
    
    override func syncronize() {
        let predicate = NSPredicate(format: "userId == %@ AND isSynchronized == %@", userId, false)
        let entities = try? Vocabulary.select(context: CoreDataStack.shared.viewContext, predicate: predicate)
        entities?.forEach({ (entity) in
            let reqest = VocabularyCreateRequest(vocabulary: entity)
            firebaseDatabase.create(request: reqest, onSuccess: {
                entity.isSynchronized = true
                try? Vocabulary.update(context: CoreDataStack.shared.viewContext, entity: entity)
            }) { (error) in
                print("Error")
            }
        })
    }
    
}

final class DataSynchronizer {
    
    static let shared = DataSynchronizer()
    
    private let userSession: SessionInfoProtocol
    private let coreDataStack: CoreDataStack
    private let firebaseDatabase: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    private init() {
        self.userSession = UserSession.shared
        self.coreDataStack = CoreDataStack.shared
        self.firebaseDatabase = FirebaseDatabase()
    }
    
    // MARK: - Public methods
    
    func configure() {
        setupNofifications()
    }
    
    // MARK: - Private methods
    
    private func setupNofifications() {
        NotificationCenter.default
            .publisher(for: .reachabilityChanged)
            .compactMap({ $0.object as? Reachability })
            .map({ $0.connection })
            .sink { [weak self] in
                if $0 != .unavailable {
                    self?.synchronize()
                }
        }.store(in: &cancellables)
    }
    
    private func synchronize() {
        guard let userId = userSession.userId else { return }
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .background
        operationQueue.addOperations([
            VocabularySyncronizeOperation(userId: userId)
        ], waitUntilFinished: false)
    }
    
}
