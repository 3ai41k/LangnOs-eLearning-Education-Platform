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
    func didCentreButtonTouch(by index: Int)
}

final class RootViewModel {
    
    // MARK: - Private properties
    
    private let router: AlertPresentableProtocol
    private let context: RootContextProtocol
    private let tabBarProviders: [TabBarProvider]
    
    // MARK: - Init
    
    init(router: AlertPresentableProtocol,
         context: RootContextProtocol) {
        self.router = router
        self.context = context
        self.tabBarProviders = TabBarProvider.allCases
    }
    
}

// MARK: - RootViewModelInputProtocol

extension RootViewModel: RootViewModelInputProtocol {
    
    func getTabBarCoordinators() -> [Coordinator] {
        tabBarProviders.map({
            $0.generateCoordinator(context: context, parentViewController: nil)
        })
    }
    
}

// MARK: - RootViewModelOutputProtocol

extension RootViewModel: RootViewModelOutputProtocol {
    
    func didCentreButtonTouch(by index: Int) {
        context.didCentreButtonTouch()
    }
    
}
