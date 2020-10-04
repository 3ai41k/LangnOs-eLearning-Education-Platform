//
//  CreateVocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CreateVocabularyNavigationProtocol: CoordinatorClosableProtocol {
    
}

final class CreateVocabularyCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let createVocabularyViewModel = CreateVocabularyViewModel(router: self)
        let createVocabularyViewController = CreateVocabularyViewController()
        createVocabularyViewController.viewModel = createVocabularyViewModel
        
        let navigationController = UINavigationController(rootViewController: createVocabularyViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController = navigationController
        parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    
}

// MARK: - CreateVocabularyNavigationProtocol

extension CreateVocabularyCoordinator: CreateVocabularyNavigationProtocol {
    
}
