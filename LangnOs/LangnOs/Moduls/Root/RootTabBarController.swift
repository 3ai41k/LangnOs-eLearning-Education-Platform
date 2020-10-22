//
//  RootTabBarController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class RootTabBarController: CentreButtonTabBarController {
    
    // MARK: - Public properties
    
    var viewModel: (RootViewModelInputProtocol & RootViewModelOutputProtocol)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponents()
        bindViewModel()
    }
    
    // MARK: - Private methods
    
    private func initializeComponents() {
        delegate = self
    }
    
    private func bindViewModel() {
        viewControllers = viewModel?.getTabBarCoordinators().compactMap({
            $0.start()
            return $0.viewController
        }) ?? []
    }
    
}

// MARK: - CentreButtonTabBarControllerDelegate

extension RootTabBarController: CentreButtonTabBarControllerDelegate {
    
    func centreButtonTabBarControllerfor(_ centreButtonTabBarControllerfor: CentreButtonTabBarController, didCentreButtonTouchFor viewController: UIViewController) {
        if let index = centreButtonTabBarControllerfor.viewControllers.firstIndex(of: viewController) {
            viewModel?.didCentreButtonTouch(by: index)
        }
    }
    
}
