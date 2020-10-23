//
//  MaterialsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MaterialsCoordinatorNavigationProtocol {
    
}

typealias MaterialsCoordinatorProtocol =
    MaterialsCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class MaterialsCoordinator: Coordinator  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = MaterialsViewModel()
        
        let cellFactory = MaterialsCellFactory()
        let layout = SquareGridFlowLayout(numberOfItemsPerRow: 2)
        
        let viewController = MaterialsViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        viewController.layout = layout
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - MaterialsCoordinatorNavigationProtocol

extension MaterialsCoordinator: MaterialsCoordinatorNavigationProtocol {
    
}


