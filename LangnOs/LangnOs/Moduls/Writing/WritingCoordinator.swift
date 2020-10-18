//
//  WritingCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 18.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol WritingCoordinatorNavigationProtocol {
    
}

typealias WritingCoordinatorProtocol =
    WritingCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class WritingCoordinator: Coordinator  {
    
    // MARK: - Private properties
    
    private let words: [Word]
    
    // MARK: - Init
    
    init(words: [Word], parentViewController: UIViewController?) {
        self.words = words
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = WritingViewModel(words: words)
        let viewController = WritingViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - WritingCoordinatorNavigationProtocol

extension WritingCoordinator: WritingCoordinatorNavigationProtocol {
    
}


