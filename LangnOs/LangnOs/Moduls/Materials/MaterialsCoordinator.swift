//
//  MaterialsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MaterialsCoordinatorNavigationProtocol {
    func navigateToCreateVocabulary(_ completion: @escaping (Vocabulary) -> Void)
    func navigateToVocabulary(_ vocabulary: Vocabulary)
}

typealias MaterialsCoordinatorProtocol =
    MaterialsCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class MaterialsCoordinator: Coordinator, MaterialsCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = DataFacade()
        let securityManager = SecurityManager.shared
        
        let viewModel = MaterialsViewModel(router: self,
                                           dataProvider: dataProvider,
                                           securityManager: securityManager)
        
        let cellFactory = MaterialsCellFactory()
        let layout = SquareGridFlowLayout(numberOfItemsPerRow: 2)
        
        let viewController = MaterialsViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        viewController.layout = layout
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - MaterialsCoordinatorNavigationProtocol
    
    func navigateToCreateVocabulary(_ completion: @escaping (Vocabulary) -> Void) {
        let createVocabularyCoordinator = CreateVocabularyCoordinator(didVocabularyCreateHandler: completion, parentViewController: viewController)
        createVocabularyCoordinator.start()
    }
    
    func navigateToVocabulary(_ vocabulary: Vocabulary) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary, didVocabularyRemoveHandler: { }, parentViewController: viewController)
        vocabularyCoordinator.start()
    }
    
}

