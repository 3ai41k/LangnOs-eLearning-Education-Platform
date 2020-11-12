//
//  RootViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol RootViewModelInputProtocol {
    func maintenance()
    func getTabBarCoordinators() -> [Coordinator]
}

final class RootViewModel {
    
    // MARK: - Private properties
    
    private let router: RootCoordinatorProtocol
    
    private var isSynchronized = false
    
    // MARK: - Init
    
    init(router: RootCoordinatorProtocol) {
        self.router = router
    }
    
}

// MARK: - RootViewModelInputProtocol

extension RootViewModel: RootViewModelInputProtocol {
    
    func maintenance() {
        guard !isSynchronized else { return }
        
        router.navigateToMaintenance()
        isSynchronized = true
    }
    
    func getTabBarCoordinators() -> [Coordinator] {
        TabBarProvider.allCases.map({
            $0.generateCoordinator(parentViewController: nil)
        })
    }
    
}
