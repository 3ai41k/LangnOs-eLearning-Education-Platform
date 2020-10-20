//
//  VocabularyFilterCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyFilterCoordinatorNavigationProtocol {
    func selectVocabularyFilter()
}

typealias VocabularyFilterCoordinatorProtocol =
    VocabularyFilterCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class VocabularyFilterCoordinator: Coordinator, VocabularyFilterCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let didVocabularyFilerSelece: () -> Void
    
    // MARK: - Init
    
    init(didVocabularyFilerSelece: @escaping () -> Void, parentViewController: UIViewController?) {
        self.didVocabularyFilerSelece = didVocabularyFilerSelece
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = VocabularyFilterViewModel(router: self)
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
    
    func selectVocabularyFilter() {
        close {
            self.didVocabularyFilerSelece()
        }
    }
    
}


