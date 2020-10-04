//
//  WordsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class WordsCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private let words: [Word]
    
    // MARK: - Init
    
    init(words: [Word], parentViewController: UIViewController?) {
        self.words = words
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let wordsViewController = WordsViewController()
        
        viewController = wordsViewController
        (parentViewController as? UINavigationController)?.pushViewController(wordsViewController, animated: true)
    }
    
    
}
