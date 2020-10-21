//
//  VocabularyFilterCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyFilterCoordinatorNavigationProtocol {
    func selectVocabularyFilter(_ filter: VocabularyFilter)
}

typealias VocabularyFilterCoordinatorProtocol =
    VocabularyFilterCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol
    

final class VocabularyFilterCoordinator: Coordinator, VocabularyFilterCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let selectedFilter: VocabularyFilter
    private let selectFilterHandler: (VocabularyFilter) -> Void
    
    // MARK: - Init
    
    init(selectedFilter: VocabularyFilter,
         selectFilterHandler: @escaping (VocabularyFilter) -> Void,
         parentViewController: UIViewController?) {
        self.selectedFilter = selectedFilter
        self.selectFilterHandler = selectFilterHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = VocabularyFilterViewModel(router: self, selectedFilter: selectedFilter)
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
    
    func selectVocabularyFilter(_ filter: VocabularyFilter) {
        close {
            self.selectFilterHandler(filter)
        }
    }
    
}


