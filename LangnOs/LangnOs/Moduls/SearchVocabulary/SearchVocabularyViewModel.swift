//
//  SearchVocabularyViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

private enum SectionType: Int {
    case vocabulary
}

final class SearchVocabularyViewModel: VocabularyListViewModelProtocol {
    
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
        
        self.fetchData()
    }
    
    // MARK: - Public methods
    
    func fetchData() {
        let request = SearchVocabularyRequest(searchText: "1", searchBy: .name)
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


