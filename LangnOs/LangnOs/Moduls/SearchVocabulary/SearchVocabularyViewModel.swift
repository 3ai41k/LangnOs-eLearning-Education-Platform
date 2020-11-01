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
}

protocol SearchVocabularyViewModelOutputProtocol {
    func search(text: String)
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
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Public properties
    // MARK: - Private properties
    
    private let router: SearchVocabularyCoordinatorProtocol
    private let firebaseDatabase: FirebaseDatabaseFetchingProtocol
    private let userSession: SessionInfoProtocol
    
    // MARK: - Init
    
    init(router: SearchVocabularyCoordinatorProtocol,
         firebaseDatabase: FirebaseDatabaseFetchingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.firebaseDatabase = firebaseDatabase
        self.userSession = userSession
        
        self.setupVocabularySection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func search(text: String) {
        guard !text.isEmpty else {
            tableSections[SectionType.vocabulary.rawValue].cells.value = .empty
            return
        }
        
        let request = SearchVocabularyRequest(searchText: text, searchBy: .name)
        firebaseDatabase.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            let cellViewModesl = vocabularies.map({ AddToFavoriteCellViewModel(vocabulary: $0, favoriteHandler: { _ in }) })
            self.tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModesl
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    // MARK: - Private methods
    
    private func setupVocabularySection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
}


