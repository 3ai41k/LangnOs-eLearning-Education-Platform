//
//  VocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol VocabularyNavigationProtocol: CoordinatorClosableProtocol {
    func navigateToFlashCards()
    func navigateToWriting()
    func navigateToWords()
    func navigateToSettings(actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>)
    func removeVocabulary()
}

final class VocabularyCoordinator: Coordinator, AlertPresentableProtocol {
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    private let removeVocabularyHandler: () -> Void
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary,
         removeVocabularyHandler: @escaping () -> Void,
         parentViewController: UIViewController?) {
        self.vocabulary = vocabulary
        self.removeVocabularyHandler = removeVocabularyHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = DataProvider()
        let viewModel = VocabularyViewModel(router: self,
                                            vocabulary: vocabulary,
                                            dataProvider: dataProvider)
        let viewController = VocabularyViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - VocabularyNavigationProtocol

extension VocabularyCoordinator: VocabularyNavigationProtocol {
    
    func navigateToFlashCards() {
        let flashCardsCoordinator = FlashCardsCoordinator(words: vocabulary.words,
                                                          parentViewController: viewController)
        flashCardsCoordinator.start()
    }
    
    func navigateToWriting() {
        let writingCoordinator = WritingCoordinator(words: vocabulary.words,
                                                    parentViewController: viewController)
        writingCoordinator.start()
    }
    
    func navigateToSettings(actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>) {
        let vocabularySettingsCoordinator = VocabularySettingsCoordinator(actionSubject: actionSubject,
                                                                          parentViewController: viewController?.tabBarController)
        vocabularySettingsCoordinator.start()
    }
    
    func navigateToWords() {
        let wordsCoordinator = WordsCoordinator(vocabulary: vocabulary,
                                                parentViewController: parentViewController)
        wordsCoordinator.start()
    }
    
    func removeVocabulary() {
        close {
            self.removeVocabularyHandler()
        }
    }
    
}
