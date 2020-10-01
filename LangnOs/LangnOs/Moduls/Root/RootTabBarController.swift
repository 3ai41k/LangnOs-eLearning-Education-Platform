//
//  RootTabBarController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController {
    
    var viewModel: RootViewModelInputProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewControllers = viewModel?.getTabBarCoordinators().compactMap({
            $0.start()
            return $0.viewController
        })
    }
    
}
