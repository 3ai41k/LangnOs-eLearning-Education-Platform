//
//  VocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol VocabularyViewModelInputProtocol {
    var title: String { get }
    var phrasesLearned: Int { get }
    var phrasesLeftToLearn: Int { get }
    var totalLearningTime: Double { get }
}

enum VocabularyViewModelAction {
    case flashCards
    case writing
    case listening
    case speaking
    case matching
    case test
    case words
    case remove
}

protocol VocabularyViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<VocabularyViewModelAction, Never> { get }
}

final class VocabularyViewModel: VocabularyViewModelOutputProtocol {
    
    // MARK: - Public properties
    
    let actionSubject = PassthroughSubject<VocabularyViewModelAction, Never>()
    
    // MARK: - Private properties
    
    private let router: VocabularyNavigationProtocol & AlertPresentableProtocol
    private let vocabulary: Vocabulary
    
    private var actionPublisher: AnyPublisher<VocabularyViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Init
    
    init(router: VocabularyNavigationProtocol & AlertPresentableProtocol,
         vocabulary: Vocabulary) {
        self.router = router
        self.vocabulary = vocabulary
        
        self.bindView()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
            actionPublisher.sink(receiveValue: { [weak self] action in
                switch action {
                case .flashCards:
                    self?.router.navigateToFlashCards()
                case .writing:
                    self?.router.navigateToWriting()
                case .listening:
                    self?.router.navigateToFlashCards()
                case .speaking:
                    self?.router.navigateToFlashCards()
                case .matching:
                    self?.router.navigateToFlashCards()
                case .test:
                    self?.router.navigateToFlashCards()
                case .words:
                    self?.router.navigateToWords()
                case .remove:
                    self?.removeVocabularyAction()
                }
            })
        ]
    }
    
    // MARK: - Actions
    
    private func removeVocabularyAction() {
        router.showAlert(title: "Are you sure?", message: "Do you want to delete this vocabulary ?", actions: [
            CancelAlertAction(handler: { }),
            OkAlertAction(handler: { self.router.removeVocabulary() })
        ])
    }
    
}

// MARK: - VocabularyViewModelInputProtocol

extension VocabularyViewModel: VocabularyViewModelInputProtocol {
    
    var title: String {
        vocabulary.title
    }
    
    var phrasesLearned: Int {
        vocabulary.phrasesLearned
    }
    
    var phrasesLeftToLearn: Int {
        vocabulary.phrasesLeftToLearn
    }
    
    var totalLearningTime: Double {
        vocabulary.totalLearningTime
    }
    
}
