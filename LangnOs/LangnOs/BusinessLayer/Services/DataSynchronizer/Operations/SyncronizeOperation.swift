//
//  SyncronizeOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

class SyncronizeOperation: Operation {
    
    // MARK: - protexted(internal) properties
    
    internal let firebaseDatabase = FirebaseDatabase.shared
    
    // MARK: - Lifecycle
    
    deinit {
        print("=> ", self)
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
