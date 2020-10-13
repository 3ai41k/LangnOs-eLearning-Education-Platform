//
//  VocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyViewModelInputProtocol: NavigatableViewModelProtocol {
    var vocabularyName: String { get }
    var numberOfWords: String { get }
    var category: String { get }
    var phrasesLearned: Int { get }
    var phrasesLeftToLearn: Int { get }
    var totalLearningTime: Double { get }
}

protocol VocabularyViewModelOutputProtocol {
    func showFlashCardsAction()
    func showWordsAction()
}

final class VocabularyViewModel {
    
    // MARK: - Private properties
    
    private let router: VocabularyNavigationProtocol & AlertPresentableProtocol
    private let dataFacade: DataFacadeDeletingProtocol
    private let vocabulary: Vocabulary
    
    // MARK: - Init
    
    init(router: VocabularyNavigationProtocol & AlertPresentableProtocol,
         dataFacade: DataFacadeDeletingProtocol,
         vocabulary: Vocabulary) {
        self.router = router
        self.dataFacade = dataFacade
        self.vocabulary = vocabulary
    }
    
    // MARK: - Actions
    
    @objc
    private func didCloseTouched() {
        router.close()
    }
    
    @objc
    private func didRemoveTouched() {
        router.showAlert(title: "Delete", message: "Are you sure?", actions: [
            CancelAlertAction(handler: nil),
            OkAlertAction(handler: {
                let request = VocabularyDeleteRequest(vocabulary: self.vocabulary)
                self.dataFacade.delete(request: request) { (error) in
                    if let error = error {
                        self.router.showAlert(title: "Error!", message: error.localizedDescription, actions: [
                            OkAlertAction(handler: { })
                        ])
                    } else {
                        self.router.removeVocabulary()
                    }
                }
            })
        ])
    }
    
}

// MARK: - VocabularyViewModelInputProtocol

extension VocabularyViewModel: VocabularyViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let closeButtonModel = BarButtonDrivableModel(title: "Close".localize,
                                                      style: .plain,
                                                      target: self,
                                                      selector: #selector(didCloseTouched))
        let removeButtonModel = BarButtonDrivableModel(title: "Remove".localize,
                                                       style: .done,
                                                       target: self,
                                                       selector: #selector(didRemoveTouched))
        return NavigationItemDrivableModel(title: nil,
                                           leftBarButtonDrivableModels: [closeButtonModel],
                                           rightBarButtonDrivableModels: [removeButtonModel])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .white,
                                   prefersLargeTitles: false)
    }
    
    var vocabularyName: String {
        vocabulary.title
    }
    
    var numberOfWords: String {
        String(format: "%d %@", vocabulary.words.count, "cards".localize)
    }
    
    var category: String {
        vocabulary.category
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
    
    func showFlashCardsAction() {
        router.navigateToFlashCards()
    }
    
    func showWordsAction() {
        router.navigateToWords()
    }
    
}
