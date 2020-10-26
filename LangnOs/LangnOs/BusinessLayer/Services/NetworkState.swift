//
//  NetworkState.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import SystemConfiguration
import Reachability
import Combine

protocol InternetConnectableProtocol {
    var isReachable: Bool { get }
}

final class NetworkState {

    // MARK: - Public properties
    
    static let shared = NetworkState()
    
    // MARK: - Private properties
    
    private var reachability: Reachability!
    
    // MARK: - Init
    
    private init() { }
    
    deinit {
        reachability.stopNotifier()
    }
    
    // MARK: - Private methods
    
    func observeReachability(){
        do {
            try reachability = Reachability()
            try reachability.startNotifier()
        } catch {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }

}

// MARK: - InternetConnectableProtocol

extension NetworkState: InternetConnectableProtocol {
    
    var isReachable: Bool {
        reachability.connection != .unavailable
    }
    
}
