//
//  VocabularyFilterCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyFilterCoordinatorNavigationProtocol {
    
}

typealias VocabularyFilterCoordinatorProtocol =
    VocabularyFilterCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class VocabularyFilterCoordinator: Coordinator  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = VocabularyFilterViewModel()
        let viewController = VocabularyFilterViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
}

// MARK: - VocabularyFilterCoordinatorNavigationProtocol

extension VocabularyFilterCoordinator: VocabularyFilterCoordinatorNavigationProtocol {
    
}


