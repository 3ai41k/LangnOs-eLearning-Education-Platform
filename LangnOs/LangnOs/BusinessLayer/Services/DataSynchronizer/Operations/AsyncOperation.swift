//
//  AsyncOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    
    // MARK: - Protexted(internal) properties
    
    internal enum State: String {
        case ready
        case executing
        case finished
        
        var keyPath: String {
            "is" + rawValue.capitalized
        }
    }
    
    internal var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    // MARK: - Override
    
    override var isReady: Bool {
        super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        state == .executing
    }
    
    override var isFinished: Bool {
        state == .finished
    }
    
    override var isAsynchronous: Bool {
        true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
    
}
