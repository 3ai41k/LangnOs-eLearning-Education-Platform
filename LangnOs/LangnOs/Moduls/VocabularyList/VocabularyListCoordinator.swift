//
//  VocabularyListCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyListNavigationProtocol {
    func addFavaoriteVocabulary(_ vocabulary: Vocabulary)
    func removeFavaoriteVocabulary(_ vocabulary: Vocabulary)
}

typealias VocabularyListCoordinatorProtocol =
    VocabularyListNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class VocabularyListCoordinator: Coordinator, VocabularyListCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let addVocabularyHandler: (Vocabulary) -> Void
    private let removeVocabularyHandler: (Vocabulary) -> Void
    
    // MARK: - Init
    
    init(addVocabularyHandler: @escaping (Vocabulary) -> Void,
         removeVocabularyHandler: @escaping (Vocabulary) -> Void,
         parentViewController: UIViewController?) {
        self.addVocabularyHandler = addVocabularyHandler
        self.removeVocabularyHandler = removeVocabularyHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let firebaseDatabase = FirebaseDatabase.shared
        let dataProvider = DataProvider(firebaseDatabase: firebaseDatabase)
        let userSession = UserSession.shared
        let viewModel = VocabularyListViewModel(router: self,
                                                dataProvider: dataProvider,
                                                userSession: userSession)
        
        let cellFactory = VocabularyListCellFactory()
        let viewController = VocabularyListViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - VocabularyListNavigationProtocol
    
    func addFavaoriteVocabulary(_ vocabulary: Vocabulary) {
        addVocabularyHandler(vocabulary)
    }
    
    func removeFavaoriteVocabulary(_ vocabulary: Vocabulary) {
        removeVocabularyHandler(vocabulary)
    }
    
}


