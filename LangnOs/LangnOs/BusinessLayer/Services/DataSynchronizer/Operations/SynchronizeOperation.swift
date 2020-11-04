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
    
    internal let firebaseDatabase = FirebaseDatabase.shared
    internal let dispatchGroup: DispatchGroup
    
    // MARK: - Lifecycle
    
    init(dispatchGroup: DispatchGroup) {
        self.dispatchGroup = dispatchGroup
        
        super.init()
    }
    
    deinit {
        print("=> deinit ", self)
    }
    
    // MARK: - Override
    
    override func main() {
        syncronize()
    }
    
    // MARK: - protexted(internal) methods
    
    internal func syncronize() {
        fatalError("\(#function) has not been implemented")
    }
    
}
