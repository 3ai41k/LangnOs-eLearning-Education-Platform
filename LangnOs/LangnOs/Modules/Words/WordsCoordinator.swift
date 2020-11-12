//
//  WordsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

typealias WordsCoordinatorProtocol =
    AlertPresentableProtocol &
    ActivityPresentableProtocol

final class WordsCoordinator: Coordinator, WordsCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary, parentViewController: UIViewController?) {
        self.vocabulary = vocabulary
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = FirebaseDatabase.shared
        let userSession = UserSession.shared
        let storage = FirebaseStorage()
        let viewModel = WordsViewModel(router: self,
                                       vocabulary: vocabulary,
                                       dataProvider: dataProvider,
                                       userSession: userSession,
                                       storage: storage)
        
        let cellFactory = CreateVocabularyCellFactory()
        let viewController = WordsViewController()
        viewController.cellFactory = cellFactory
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}
