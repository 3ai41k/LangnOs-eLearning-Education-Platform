//
//  RootTabBarController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController {
    
    // MARK: - Public properties
    
    var viewModel: (RootViewModelInputProtocol & RootViewModelOutputProtocol)? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponents()
    }
    
    // MARK: - Private methods
    
    private func initializeComponents() {
        delegate = self
    }
    
    private func bindViewModel() {
        viewControllers = viewModel?.getTabBarCoordinators().compactMap({
            $0.start()
            return $0.viewController
        })
    }
    
}

// MARK: - UITabBarControllerDelegate

extension RootTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard
            let viewModel = viewModel,
            let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        else {
            return false
        }
        return viewModel.shouldNavigateToTheArea(index)
    }
    
}
