//
//  CreateVocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CreateVocabularyNavigationProtocol: CoordinatorClosableProtocol {
    func vocabularyDidCreate()
}

typealias CreateVocabularyCoordinatorProtocol = CreateVocabularyNavigationProtocol & ActivityPresentableProtocol & AlertPresentableProtocol

final class CreateVocabularyCoordinator: Coordinator, CreateVocabularyCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private var didCreateHandler: () -> Void
    
    // MARK: - Init
    
    init(didVocabularyCreateHandler: @escaping () -> Void, parentViewController: UIViewController?) {
        self.didCreateHandler = didVocabularyCreateHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let securityInfo = SecurityInfo()
        let fireBaseDatabase = FirebaseDatabase()
        let createVocabularyViewModel = CreateVocabularyViewModel(userInfo: securityInfo,
                                                                  fireBaseDatabase: fireBaseDatabase,
                                                                  router: self)
        let createVocabularyCellFactory = CreateVocabularyCellFactory()
        let createVocabularyViewController = CreateVocabularyViewController()
        createVocabularyViewController.tableViewCellFactory = createVocabularyCellFactory
        createVocabularyViewController.viewModel = createVocabularyViewModel
        
        let navigationController = UINavigationController(rootViewController: createVocabularyViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController = navigationController
        parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - CreateVocabularyNavigationProtocol
    
    func vocabularyDidCreate() {
        close {
            self.didCreateHandler()
        }
    }
    
}
