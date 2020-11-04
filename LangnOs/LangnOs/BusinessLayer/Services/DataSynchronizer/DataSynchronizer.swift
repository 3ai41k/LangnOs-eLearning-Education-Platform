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
    
    // MARK: - Private methods
    
    private let operationQueue: OperationQueue
    private let dispatchGroup: DispatchGroup
    
    // MARK: - Init
    
    init() {
        self.operationQueue = OperationQueue()
        self.dispatchGroup = DispatchGroup()
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
            VocabularySynchronizeOperation(dispatchGroup: dispatchGroup)
        ], waitUntilFinished: false)
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
    
}
