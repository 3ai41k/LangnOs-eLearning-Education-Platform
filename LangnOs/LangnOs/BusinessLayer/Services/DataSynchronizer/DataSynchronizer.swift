//
//  DataSynchronizer.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Reachability
import Combine

final class DataSynchronizer {
    
    static let shared = DataSynchronizer()
    
    private let userSession: SessionInfoProtocol
    private let coreDataStack: CoreDataStack
    private let firebaseDatabase: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol
    
    private let operationQueue: OperationQueue
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    private init() {
        self.userSession = UserSession.shared
        self.coreDataStack = CoreDataStack.shared
        self.firebaseDatabase = FirebaseDatabase.shared
        
        self.operationQueue = OperationQueue()
    }
    
    // MARK: - Public methods
    
    func configure() {
        setupNofifications()
    }
    
    func cancelAllOperations() {
        operationQueue.cancelAllOperations()
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
        
        operationQueue.qualityOfService = .background
        operationQueue.addOperations([
            VocabularySyncronizeOperation(userId: userId)
        ], waitUntilFinished: false)
    }
    
}
