//
//  WordsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol WordsViewModelInputProtocol {
    var title: String { get }
}

protocol WordsViewModelOutputProtocol {
    func setEditing(_ editing: Bool)
}

typealias WordsViewModelProtocol =
    WordsViewModelInputProtocol &
    WordsViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case words
}

final class WordsViewModel: WordsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Words".localize
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: WordsCoordinatorProtocol
    private var vocabulary: Vocabulary
    private let dataProvider: FirebaseDatabaseUpdatingProtocol
    private let userSession: SessionInfoProtocol
    private let storage: FirebaseStorageFetchingProtocol
    
    // MARK: - Init
    
    init(router: WordsCoordinatorProtocol,
         vocabulary: Vocabulary,
         dataProvider: FirebaseDatabaseUpdatingProtocol,
         userSession: SessionInfoProtocol,
         storage: FirebaseStorageFetchingProtocol) {
        self.router = router
        self.vocabulary = vocabulary
        self.dataProvider = dataProvider
        self.userSession = userSession
        self.storage = storage
        
        self.appendWordSection()
    }
    
    // MARK: - Public methods
    
    func deleteItemForRowAt(indexPath: IndexPath) {
        tableSections[SectionType.words.rawValue].cells.value.remove(at: indexPath.row)
    }
    
    func setEditing(_ editing: Bool) {
        tableSections[SectionType.words.rawValue].cells.value.forEach({
            ($0 as? WordRepresentionCellViewModel)?.isEditable.value = editing
        })
        if editing == false {
            updateWords()
        }
    }
    
    // MARK: - Private methods
    
    private func appendWordSection() {
        let cellViewModels = vocabulary.words.map({
            WordRepresentionCellViewModel(vocabularyId: vocabulary.id,
                                          word: $0,
                                          userSession: userSession,
                                          storage: storage)
        })
        tableSections.append(TableSectionViewModel(cells: cellViewModels))
    }
    
    private func updateWords() {
        let words = tableSections[SectionType.words.rawValue].cells.value.compactMap({
            ($0 as? WordRepresentionCellViewModel)?.word
        })
        
        if vocabulary.words != words {
            router.showActivity()
            
            vocabulary.words = words
            
            let request = VocabularyUpdateRequest(vocabulary: vocabulary)
            dataProvider.update(request: request, onSuccess: {
                self.router.closeActivity()
            }) { (error) in
                self.router.closeActivity()
                self.router.showError(error)
                
                let cellViewModels = self.vocabulary.words.map({
                    WordRepresentionCellViewModel(vocabularyId: self.vocabulary.id,
                                                  word: $0,
                                                  userSession: self.userSession,
                                                  storage: self.storage)
                })
                self.tableSections[SectionType.words.rawValue].cells.value = cellViewModels
            }
        }
    }
    
}
