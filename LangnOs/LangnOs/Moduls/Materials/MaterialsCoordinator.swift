//
//  MaterialsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MaterialsCoordinatorNavigationProtocol {
    func navigateToCreateVocabulary(_ createHandler: @escaping (Vocabulary) -> Void)
    func navigateToVocabulary(_ vocabulary: Vocabulary, removeVocabularyHandler: @escaping () -> Void)
}

typealias MaterialsCoordinatorProtocol =
    MaterialsCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    AlertPresentableProtocol
    

final class MaterialsCoordinator: Coordinator, MaterialsCoordinatorProtocol  {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = DataProvider()
        let userSession = UserSession.shared
        let viewModel = MaterialsViewModel(router: self,
                                           dataProvider: dataProvider,
                                           userSession: userSession)
        
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
    
    func navigateToCreateVocabulary(_ createHandler: @escaping (Vocabulary) -> Void) {
        let createVocabularyCoordinator = CreateVocabularyCoordinator(createHandler: createHandler,
                                                                      parentViewController: viewController)
        createVocabularyCoordinator.start()
    }
    
    func navigateToVocabulary(_ vocabulary: Vocabulary, removeVocabularyHandler: @escaping () -> Void) {
        let vocabularyCoordinator = VocabularyCoordinator(vocabulary: vocabulary,
                                                          parentViewController: parentViewController)
        vocabularyCoordinator.removeVocabularyHandler = removeVocabularyHandler
        vocabularyCoordinator.start()
    }
    
}

