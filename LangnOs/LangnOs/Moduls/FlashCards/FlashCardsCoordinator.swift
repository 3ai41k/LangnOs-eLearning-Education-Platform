//
//  FlashCardsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class FlashCardsCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private let words: [Word]
    
    // MARK: - Init
    
    init(words: [Word], parentViewController: UIViewController?) {
        self.words = words
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let flashCardsViewModel = FlashCardsViewModel(words: words)
        let flashCardsCellFactory = FlashCardsCellFactory()
        let flashCardsViewController = FlashCardsViewController()
        flashCardsViewController.viewModel = flashCardsViewModel
        flashCardsViewController.tableViewCellFactory = flashCardsCellFactory
        
        viewController = flashCardsViewController
        (parentViewController as? UINavigationController)?.pushViewController(flashCardsViewController, animated: true)
    }
    
}
