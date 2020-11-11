//
//  PresentationCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class PresentationCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = PresentationViewModel()
        let viewController = PresentationViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
}
