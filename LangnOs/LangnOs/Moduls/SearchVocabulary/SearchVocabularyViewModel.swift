//
//  SearchVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol SearchVocabularyViewModelInputProtocol {
    var title: String { get }
    var backgoundViewTitle: String { get }
    var scopeButtonTitles: [String] { get }
}

protocol SearchVocabularyViewModelOutputProtocol {
    func search(text: String)
    func selectedScopeButtonFor(index: Int)
}

private enum SectionType: Int {
    case vocabulary
}

typealias SearchVocabularyViewModelPrtotocol =
    SearchVocabularyViewModelInputProtocol &
    SearchVocabularyViewModelOutputProtocol &
    UniversalTableViewModelProtocol

final class SearchVocabularyViewModel: SearchVocabularyViewModelPrtotocol {
    
    var title: String {
        "Search".localize
    }
    
    var backgoundViewTitle: String {
        "There aren't any materials.".localize
    }
    
    var scopeButtonTitles: [String] {
        SearchVocabularBy.allCases.map({ $0.title })
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Public properties
    // MARK: - Private properties
    
    private let router: SearchVocabularyCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol
    private let storage: FirebaseStorageFetchingProtocol
    private let userSession: SessionInfoProtocol
    
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            let cellViewModesl = vocabularies.map({ (vocabulary) in
                SearchVocabularyCellViewModel(vocabulary: vocabulary, storage: storage) { [weak self] in
                    self?.saveVocabulary(vocabulary)
                }
            })
            tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModesl
        }
    }
    private var searchVocabularBy: SearchVocabularBy = .name
    
    // MARK: - Init
    
    init(router: SearchVocabularyCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseCreatingProtocol,
         storage: FirebaseStorageFetchingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.storage = storage
        self.userSession = userSession
        
        self.setupVocabularySection()
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabularyPreview(vocabulary)
    }
    
    func selectedScopeButtonFor(index: Int) {
        searchVocabularBy = SearchVocabularBy.allCases[index]
    }
    
    func search(text: String) {
        guard !text.isEmpty else {
            vocabularies = .empty
            return
        }
        
        let request = SearchVocabularyRequest(searchText: text, searchBy: searchVocabularBy)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            self.vocabularies = vocabularies
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    // MARK: - Private methods
    
    private func setupVocabularySection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func saveVocabulary(_ vocabulary: Vocabulary) {
        guard let userId = userSession.currentUser?.id, vocabulary.id != userId else {
            router.showAlert(title: "Error!",
                             message: "You can not save your own vocabulary",
                             actions: [OkAlertAction(handler: { })])
            return
        }
        
        var newVocabulary = Vocabulary(userId: userId,
                                       title: vocabulary.title,
                                       category: vocabulary.category,
                                       isPrivate: false)
        newVocabulary.words = vocabulary.words
        
        router.showActivity()
        let request = VocabularyCreateRequest(vocabulary: newVocabulary)
        dataProvider.create(request: request, onSuccess: {
            self.router.closeActivity()
        }) { (error) in
            self.router.showError(error)
        }
    }
    
}


