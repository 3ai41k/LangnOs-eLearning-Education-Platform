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
        let dataProvider = DataProvider(firebaseDatabase: FirebaseDatabase.shared)
        let mediaDownloader = MediaDownloader()
        let viewModel = WordsViewModel(router: self,
                                       vocabulary: vocabulary,
                                       dataProvider: dataProvider,
                                       mediaDownloader: mediaDownloader)
        
        let cellFactory = CreateVocabularyCellFactory()
        let viewController = WordsViewController()
        viewController.tableViewCellFactory = cellFactory
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}
