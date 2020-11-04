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
    case settings
}

protocol VocabularyViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<VocabularyViewModelAction, Never> { get }
}

final class VocabularyViewModel: VocabularyViewModelOutputProtocol {
    
    // MARK: - Public properties
    
    let actionSubject = PassthroughSubject<VocabularyViewModelAction, Never>()
    
    // MARK: - Private properties
    
    private let router: VocabularyCoordinatorProtocol
    private var vocabulary: Vocabulary
    private let dataProvider: FirebaseDatabaseUpdatingProtocol & FirebaseDatabaseDeletingProtocol
    
    private var actionPublisher: AnyPublisher<VocabularyViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private let settingsActionSubject = PassthroughSubject<VocabularySettingsRowAction, Never>()
    private var settingsActionPublisher: AnyPublisher<VocabularySettingsRowAction, Never> {
        settingsActionSubject.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Init
    
    init(router: VocabularyCoordinatorProtocol,
         vocabulary: Vocabulary,
         dataProvider: FirebaseDatabaseUpdatingProtocol & FirebaseDatabaseDeletingProtocol) {
        self.router = router
        self.vocabulary = vocabulary
        self.dataProvider = dataProvider
        
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
                case .settings:
                    guard let self = self else { return }
                    self.router.navigateToSettings(actionSubject: self.settingsActionSubject)
                }
            }),
            settingsActionPublisher.sink(receiveValue: { [weak self] action in
                switch action {
                case .rename:
                    print(#function)
                case .resetStatistic:
                    print(#function)
                case .favorite:
                    self?.addVocabularyToFavorite()
                case .delete:
                    self?.deleteVocavulary()
                }
            })
        ]
    }
    
    private func deleteVocavulary() {
        router.showAlert(title: "Are you sure ?", message: "Do you want to delete this vocabulary ?", actions: [
            CancelAlertAction(handler: { }),
            OkAlertAction(handler: {
                self.router.showActivity()
                
                let request = VocabularyDeleteRequest(vocabulary: self.vocabulary)
                self.dataProvider.delete(request: request, onSuccess: {
                    self.router.closeActivity()
                    self.router.close()
                }) { (error) in
                    self.router.closeActivity()
                    self.router.showError(error)
                }
            })
        ])
    }
    
    private func addVocabularyToFavorite() {
//        vocabulary.isFavorite = vocabulary.isFavorite ? false : true
//        let request = VocabularyUpdateRequest(vocabulary: vocabulary)
//        dataProvider.update(request: request, onSuccess: {
//            print("Success")
//        }) { (error) in
//            self.router.showError(error)
//        }
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
