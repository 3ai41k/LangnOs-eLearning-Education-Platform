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
        let presentationViewModel = PresentationViewModel()
        let presentationViewController = PresentationViewController()
        presentationViewController.viewModel = presentationViewModel
        
        viewController = presentationViewController
    }
    
}
