//
//  SyncronizeOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

class SynchronizeOperation: AsyncOperation {
    
    // MARK: - Protexted(internal) properties
    
    internal let firebaseDatabase: FirebaseDatabaseProtocol
    
    // MARK: - Private properties
    
    private let completion: () -> Void
    private let networkState: InternetConnectableProtocol
    
    // MARK: - Lifecycle
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        
        self.firebaseDatabase = FirebaseDatabase.shared
        self.networkState = NetworkState.shared
        
        super.init()
    }
    
    deinit {
        print("=> deinit ", self)
        completion()
    }
    
    // MARK: - Override
    
    override func main() {
        if networkState.isReachable {
            syncronize()
        } else {
            state = .finished
        }
    }
    
    // MARK: - protexted(internal) methods
    
    internal func syncronize() {
        fatalError("\(#function) has not been implemented")
    }
    
}
