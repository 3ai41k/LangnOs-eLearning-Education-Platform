//
//  VocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol VocabularyNavigationProtocol {
    func navigateToFlashCards()
    func navigateToWriting()
    func navigateToWords()
    func navigateToSettings(actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>)
}

typealias VocabularyCoordinatorProtocol =
    VocabularyNavigationProtocol &
    CoordinatorClosableProtocol &
    AlertPresentableProtocol &
    ActivityPresentableProtocol

final class VocabularyCoordinator: Coordinator, VocabularyCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    
    // MARK: - Public properties
    
    var removeVocabularyHandler: (() -> Void)?
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary, parentViewController: UIViewController?) {
        self.vocabulary = vocabulary
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = DataProvider(firebaseDatabase: FirebaseDatabase.shared)
        let storage = FirebaseStorage()
        let viewModel = VocabularyViewModel(router: self,
                                            vocabulary: vocabulary,
                                            dataProvider: dataProvider,
                                            storage: storage)
        
        let viewController = VocabularyViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - CoordinatorClosableProtocol
    
    func close(completion: (() -> Void)?) {
        (parentViewController as? UINavigationController)?.popViewController(animated: true)
        completion?()
        removeVocabularyHandler?()
    }
    
    // MARK: - VocabularyNavigationProtocol
    
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
    
}
