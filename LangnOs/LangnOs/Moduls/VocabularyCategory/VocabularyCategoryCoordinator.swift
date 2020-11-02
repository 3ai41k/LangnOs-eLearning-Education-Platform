//
//  VocabularyCategoryCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyCategoryCoordinatorNavigationProtocol {
    
}

typealias VocabularyCategoryCoordinatorProtocol =
    VocabularyCategoryCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class VocabularyCategoryCoordinator: Coordinator, VocabularyCategoryCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let sourceView: UIView
    
    // MARK: - Init
    
    init(sourceView: UIView, parentViewController: UIViewController?) {
        self.sourceView = sourceView
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = VocabularyCategoryViewModel()
        let viewController = VocabularyCategoryViewController()
        viewController.viewModel = viewModel
        
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: 300.0, height: 300.0)
        
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
    
}


