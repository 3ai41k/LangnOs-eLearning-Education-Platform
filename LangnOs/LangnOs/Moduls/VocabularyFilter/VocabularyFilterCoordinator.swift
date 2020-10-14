//
//  VocabularyFilterCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyFilterCoordinatorNavigationProtocol {
    func selectVocabularyFilter(_ vocabularyFilter: VocabularyFilter)
}

typealias VocabularyFilterCoordinatorProtocol =
    VocabularyFilterCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class VocabularyFilterCoordinator: Coordinator, VocabularyFilterCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let didVocabularyFilerSelece: (VocabularyFilter) -> Void
    
    // MARK: - Init
    
    init(didVocabularyFilerSelece: @escaping (VocabularyFilter) -> Void, parentViewController: UIViewController?) {
        self.didVocabularyFilerSelece = didVocabularyFilerSelece
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let dataFacade = DataFacade()
        let viewModel = VocabularyFilterViewModel(router: self, dataFacade: dataFacade, selectedVocabularyFilter: nil)
        let cellFactory = VocabularyFilterCellFactory()
        let viewController = VocabularyFilterViewController()
        viewController.cellFactory = cellFactory
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (self.parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - CoordinatorClosableProtocol
    
    func close(completion: (() -> Void)?) {
        (self.parentViewController as? UINavigationController)?.popViewController(animated: true)
        completion?()
        
    }
    
    // MARK: - VocabularyFilterCoordinatorNavigationProtocol
    
    func selectVocabularyFilter(_ vocabularyFilter: VocabularyFilter) {
        close {
            self.didVocabularyFilerSelece(vocabularyFilter)
        }
    }
    
}


