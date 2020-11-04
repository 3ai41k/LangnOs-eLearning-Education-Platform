//
//  RootViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol RootViewModelInputProtocol {
    func getTabBarCoordinators() -> [Coordinator]
}

final class RootViewModel {
    
    // MARK: - Private properties
    
    private let router: RootNavigationProtocol
    
    // MARK: - Init
    
    init(router: RootNavigationProtocol) {
        self.router = router
    }
    
}

// MARK: - RootViewModelInputProtocol

extension RootViewModel: RootViewModelInputProtocol {
    
    func getTabBarCoordinators() -> [Coordinator] {
        TabBarProvider.allCases.map({
            $0.generateCoordinator(parentViewController: nil)
        })
    }
    
}
