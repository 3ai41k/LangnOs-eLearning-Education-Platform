//
//  NetworkState.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Reachability

protocol InternetConnectableProtocol {
    var isReachable: Bool { get }
}

//
// MARK: Notifications work correctly only on real device
//

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
    
    // MARK: - Public methods
    
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
