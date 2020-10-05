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
        let fireBaseDatabase = FirebaseDatabase()
        let createVocabularyCellFactory = CreateVocabularyCellFactory()
        let createVocabularyViewModel = CreateVocabularyViewModel(fireBaseDatabase: fireBaseDatabase, router: self)
        let createVocabularyViewController = CreateVocabularyViewController()
        createVocabularyViewController.tableViewCellFactory = createVocabularyCellFactory
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
