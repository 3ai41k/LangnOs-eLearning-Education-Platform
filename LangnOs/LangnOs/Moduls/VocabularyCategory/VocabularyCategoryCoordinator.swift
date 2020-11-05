//
//  VocabularyCategoryCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyCategoryCoordinatorNavigationProtocol {
    func selectCategory(_ category: Category)
}

typealias VocabularyCategoryCoordinatorProtocol =
    VocabularyCategoryCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol

final class VocabularyCategoryCoordinator: Coordinator, VocabularyCategoryCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let sourceView: UIView
    private let didCategorySelect: (Category) -> Void
    
    // MARK: - Init
    
    init(sourceView: UIView, didCategorySelect: @escaping (Category) -> Void, parentViewController: UIViewController?) {
        self.sourceView = sourceView
        self.didCategorySelect = didCategorySelect
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = VocabularyCategoryViewModel(router: self)
        let cellFactory = VocabularyCategoryCellFactory()
        let viewController = VocabularyCategoryViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: 250.0, height: 150.0)
        
        let popover = viewController.popoverPresentationController
        popover?.delegate = viewController
        popover?.sourceView = sourceView
        popover?.sourceRect = CGRect(x: sourceView.bounds.minX,
                                     y: sourceView.bounds.midY,
                                     width: .zero,
                                     height: .zero)
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - VocabularyCategoryCoordinatorNavigationProtocol
    
    func selectCategory(_ category: Category) {
        close {
            self.didCategorySelect(category)
        }
    }
    
}


