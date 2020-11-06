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

protocol VocabularyViewModelOutputProtocol {
    func flashCardsAction()
    func writingAction()
    func listeningAction()
    func speakingAction()
    func matchingAction()
    func testAction()
    func wordsAction()
    func settingsAction()
}

final class VocabularyViewModel {
    
    // MARK: - Private properties
    
    private let router: VocabularyCoordinatorProtocol
    private let vocabulary: Vocabulary
    private let dataProvider: FirebaseDatabaseUpdatingProtocol & FirebaseDatabaseDeletingProtocol
    private let storage: FirebaseStorageRemovingProtocol
    
    private let settingsActionSubject = PassthroughSubject<VocabularySettingsRowAction, Never>()
    private var settingsActionPublisher: AnyPublisher<VocabularySettingsRowAction, Never> {
        settingsActionSubject.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Init
    
    init(router: VocabularyCoordinatorProtocol,
         vocabulary: Vocabulary,
         dataProvider: FirebaseDatabaseUpdatingProtocol & FirebaseDatabaseDeletingProtocol,
         storage: FirebaseStorageRemovingProtocol) {
        self.router = router
        self.vocabulary = vocabulary
        self.dataProvider = dataProvider
        self.storage = storage
        
        self.bindView()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
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
                self.deleteVocabularyImages {
                    let request = VocabularyDeleteRequest(vocabulary: self.vocabulary)
                    self.dataProvider.delete(request: request, onSuccess: {
                        self.router.closeActivity()
                        self.router.close()
                    }) { (error) in
                        self.router.closeActivity()
                        self.router.showError(error)
                    }
                }
            })
        ])
    }
    
    private func deleteVocabularyImages(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        vocabulary.words.forEach({
            let request = DeleteTermImageRequest(userId: vocabulary.userId, vocabularyId: vocabulary.id, imageName: $0.term)
            
            dispatchGroup.enter()
            self.storage.delete(request: request, onSuccess: {
                dispatchGroup.leave()
            }) { (error) in
                print(error.localizedDescription)
                dispatchGroup.leave()
            }
        })
        dispatchGroup.notify(queue: .main, execute: completion)
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

// MARK: - VocabularyViewModelOutputProtocol

extension VocabularyViewModel: VocabularyViewModelOutputProtocol {
    
    func flashCardsAction() {
        router.navigateToFlashCards()
    }
    
    func writingAction() {
        router.navigateToWriting()
    }
    
    func listeningAction() {
        router.navigateToFlashCards()
    }
    
    func speakingAction() {
        router.navigateToFlashCards()
    }
    
    func matchingAction() {
        router.navigateToFlashCards()
    }
    
    func testAction() {
        router.navigateToFlashCards()
    }
    
    func wordsAction() {
        router.navigateToWords()
    }
    
    func settingsAction() {
        router.navigateToSettings(actionSubject: settingsActionSubject)
    }
    
}
