//
//  VocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyNavigationProtocol: CoordinatorClosableProtocol {
    func navigateToWords()
}

final class VocabularyCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary, parentViewController: UIViewController?) {
        self.vocabulary = vocabulary
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let vocabularyViewModel = VocabularyViewModel(router: self, vocabulary: vocabulary)
        let vocabularyViewController = VocabularyViewController()
        vocabularyViewController.viewModel = vocabularyViewModel
        
        let navigationController = UINavigationController(rootViewController: vocabularyViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController = navigationController
        parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - VocabularyNavigationProtocol

extension VocabularyCoordinator: VocabularyNavigationProtocol {
    
    func navigateToWords() {
        let wordsCoordinator = WordsCoordinator(words: vocabulary.words, parentViewController: viewController)
        wordsCoordinator.start()
    }
    
}
