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

protocol RootViewModelOutputProtocol {
    func shouldNavigateToTheArea(_ index: Int) -> Bool
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

// MARK: - RootViewModelOutputProtocol

extension RootViewModel: RootViewModelOutputProtocol {
    
    func shouldNavigateToTheArea(_ index: Int) -> Bool {
        if tabBarProviders[index].isLoced {
            router.showAlert(title: "Attention!", message: "This area is closed!", actions: [
                OkAlertAction(handler: { })
            ])
            return false
        } else {
            return true
        }
    }
    
}
