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
    var title: CurrentValueSubject<String?, Never> { get }
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
    
    var title = CurrentValueSubject<String?, Never>("Words".localize)
    var setEditingSubject = PassthroughSubject<Bool, Never>()
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: WordsCoordinatorProtocol
    private let vocabulary: Vocabulary
    private let dataProvider: DataProviderUpdatingProtocol
    
    private var setEditingPublisher: AnyPublisher<Bool, Never> {
        setEditingSubject.eraseToAnyPublisher()
    }
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Init
    
    init(router: WordsCoordinatorProtocol, vocabulary: Vocabulary, dataProvider: DataProviderUpdatingProtocol) {
        self.router = router
        self.vocabulary = vocabulary
        self.dataProvider = dataProvider
        
        self.bindView()
        
        self.setupWordSection(&tableSections)
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
    
    private func setupWordSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = vocabulary.words.map({
            WordRepresentionCellViewModel(word: $0)
        })
        tableSections.append(TableSectionViewModel(cells: cellViewModels))
    }
    
    private func saveWordsIfСhanged() {
        router.showActivity()
        
        let words: [Word] = tableSections[SectionType.words.rawValue].cells.value.compactMap({
            ($0 as? WordRepresentionCellViewModel)?.word
        })
        
        if vocabulary.words != words {
            let vocabularyForUpdate = Vocabulary(update: vocabulary, words: words)
            let request = VocabularyUpdateRequest(vocabulary: vocabularyForUpdate)
            dataProvider.update(request: request) { (result) in
                self.router.closeActivity()
                switch result {
                case .success:
                    print("Success")
                case .failure(let error):
                    self.router.showError(error)
                    
                    let cellViewModels = self.vocabulary.words.map({ WordRepresentionCellViewModel(word: $0) })
                    self.tableSections[SectionType.words.rawValue].cells.value = cellViewModels
                }
            }
        }
    }
    
}
