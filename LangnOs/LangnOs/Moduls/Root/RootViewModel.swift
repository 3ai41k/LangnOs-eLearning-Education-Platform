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
    
    private let router: AlertPresentableProtocol
    private let tabBarProviders: [TabBarProvider]
    
    // MARK: - Init
    
    init(router: AlertPresentableProtocol) {
        self.router = router
        self.tabBarProviders = TabBarProvider.allCases
    }
    
}

// MARK: - RootViewModelInputProtocol

extension RootViewModel: RootViewModelInputProtocol {
    
    func getTabBarCoordinators() -> [Coordinator] {
        tabBarProviders.map({
            $0.generateCoordinator(parentViewController: nil)
        })
    }
    
}
