//
//  DataSynchronizer.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol CloudSynchronizeProtocol {
    func synchronize(completion: (() -> Void)?)
    func cancelAllOperations()
}

final class DataSynchronizer {
    
    // MARK: - Public properties
    
    static let shared = DataSynchronizer()
    
    // MARK: - Private properties
    
    private let operationQueue: OperationQueue
    
    // MARK: - Lifecycle
    
    init() {
        self.operationQueue = OperationQueue()
    }
    
}

// MARK: - CloudSynchronizeProtocol

extension DataSynchronizer: CloudSynchronizeProtocol {
    
    //
    // You can't use waitUntilFinished flag as true, because the Firebase API uses the main thread for all requests.
    // For this reason, I can recommend using a dispatchGroup to handle operation state.
    //
    
    func synchronize(completion: (() -> Void)?) {
        operationQueue.addOperations([
            VocabularySynchronizeOperation {
                completion?()
            }
        ], waitUntilFinished: false)
    }
    
    func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
    
}
