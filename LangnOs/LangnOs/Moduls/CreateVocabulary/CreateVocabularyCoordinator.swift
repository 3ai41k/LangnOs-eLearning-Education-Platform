//
//  CreateVocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CreateVocabularyNavigationProtocol: CoordinatorClosableProtocol {
    func vocabularyDidCreate(_ vocabulary: Vocabulary)
}

typealias CreateVocabularyCoordinatorProtocol = CreateVocabularyNavigationProtocol & ActivityPresentableProtocol & AlertPresentableProtocol

final class CreateVocabularyCoordinator: Coordinator, CreateVocabularyCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private var didVocabularyCreateHandler: (Vocabulary) -> Void
    
    // MARK: - Init
    
    init(didVocabularyCreateHandler: @escaping (Vocabulary) -> Void, parentViewController: UIViewController?) {
        self.didVocabularyCreateHandler = didVocabularyCreateHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let securityInfo = SecurityInfo()
        let dataFacade = DataFacade()
        let createVocabularyViewModel = CreateVocabularyViewModel(userInfo: securityInfo,
                                                                  dataFacade: dataFacade,
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
    
    func vocabularyDidCreate(_ vocabulary: Vocabulary) {
        close {
            self.didVocabularyCreateHandler(vocabulary)
        }
    }
    
}
