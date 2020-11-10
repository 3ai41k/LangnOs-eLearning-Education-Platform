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
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    private let storage: FirebaseStorageFetchingProtocol
    private let userSession: SessionInfoProtocol
    
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            let cellViewModesl = vocabularies.map({
                SearchVocabularyCellViewModel(vocabulary: $0, storage: storage)
            })
            tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModesl
        }
    }
    private var searchVocabularBy: SearchVocabularBy = .name
    
    // MARK: - Init
    
    init(router: SearchVocabularyCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol,
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
    
}


