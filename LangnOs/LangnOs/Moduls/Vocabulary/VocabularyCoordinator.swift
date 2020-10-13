//
//  VocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol VocabularyNavigationProtocol: CoordinatorClosableProtocol {
    func navigateToFlashCards()
    func navigateToWords()
    func removeVocabulary()
}

final class VocabularyCoordinator: Coordinator, AlertPresentableProtocol {
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    private let didVocabularyRemoveHandler: () -> Void
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary,
         didVocabularyRemoveHandler: @escaping () -> Void,
         parentViewController: UIViewController?) {
        self.vocabulary = vocabulary
        self.didVocabularyRemoveHandler = didVocabularyRemoveHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let dataFacade = DataFacade()
        let vocabularyViewModel = VocabularyViewModel(router: self, dataFacade: dataFacade, vocabulary: vocabulary)
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
    
    func navigateToFlashCards() {
        let flashCardsCoordinator = FlashCardsCoordinator(words: vocabulary.words, parentViewController: viewController)
        flashCardsCoordinator.start()
    }
    
    func navigateToWords() {
        let wordsCoordinator = WordsCoordinator(words: vocabulary.words, parentViewController: viewController)
        wordsCoordinator.start()
    }
    
    func removeVocabulary() {
        close {
            self.didVocabularyRemoveHandler()
        }
    }
    
}
