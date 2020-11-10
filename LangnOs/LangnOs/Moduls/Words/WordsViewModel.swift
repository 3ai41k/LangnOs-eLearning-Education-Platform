//
//  WordsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol WordsViewModelInputProtocol {
    var title: String { get }
}

protocol WordsViewModelOutputProtocol {
    var setEditingSubject: PassthroughSubject<Bool, Never> { get }
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
    
    var setEditingSubject = PassthroughSubject<Bool, Never>()
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: WordsCoordinatorProtocol
    private var vocabulary: Vocabulary
    private let dataProvider: FirebaseDatabaseUpdatingProtocol
    private let userSession: SessionInfoProtocol
    private let storage: FirebaseStorageFetchingProtocol
    
    private var setEditingPublisher: AnyPublisher<Bool, Never> {
        setEditingSubject.eraseToAnyPublisher()
    }
    private var cancellables: [AnyCancellable?] = []
    
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
        
        self.bindView()
        
        self.appendWordSection()
    }
    
    // MARK: - Public methods
    
    func deleteItemForRowAt(indexPath: IndexPath) {
        tableSections[SectionType.words.rawValue].cells.value.remove(at: indexPath.row)
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
            setEditingPublisher.sink(receiveValue: { [weak self] (isEditing) in
                self?.tableSections[SectionType.words.rawValue].cells.value.forEach({
                    ($0 as? WordRepresentionCellViewModel)?.isEditable.value = isEditing
                })
                if isEditing == false {
                    self?.saveWordsIfСhanged()
                }
            })
        ]
    }
    
    private func appendWordSection() {
        let cellViewModels = vocabulary.words.map({
            WordRepresentionCellViewModel(vocabularyId: vocabulary.id,
                                          word: $0,
                                          userSession: userSession,
                                          storage: storage)
        })
        tableSections.append(TableSectionViewModel(cells: cellViewModels))
    }
    
    private func saveWordsIfСhanged() {
        let words: [Word] = tableSections[SectionType.words.rawValue].cells.value.compactMap({
            ($0 as? WordRepresentionCellViewModel)?.word
        })
        
        if vocabulary.words != words {
            router.showActivity()
            
            vocabulary.updateWords(words)
            
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
