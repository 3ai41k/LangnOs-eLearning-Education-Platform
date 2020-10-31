//
//  VocabularyListViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol VocabularyListViewModelInputProtocol {
    var title: String { get }
}

protocol VocabularyListViewModelOutputProtocol {
    
}

typealias VocabularyListViewModelProtocol =
    VocabularyListViewModelInputProtocol &
    VocabularyListViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case main
}

final class VocabularyListViewModel: VocabularyListViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Favorites".localize
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularyListCoordinatorProtocol
    private let dataProvider: DataProviderFetchingProtocol
    private let userSession: SessionInfoProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(router: VocabularyListCoordinatorProtocol,
         dataProvider: DataProviderFetchingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.setupMainSection(&tableSections)
        
        self.fetchData()
    }
    
    // MARK: - Private methods
    
    private func fetchData() {
        guard let userId = userSession.userId else { return }
        
        let request = VocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            self.setupVocabularyCells(vocabularies)
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    private func setupMainSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func setupVocabularyCells(_ vocabularies: [Vocabulary]) {
        let cellViewModels: [CellViewModelProtocol] = vocabularies.map({ (vocabulary) in
            let cellViewModel = AddToFavoriteCellViewModel(vocabulary: vocabulary)
            cellViewModel.isFavorite.sink { [weak self] (isFavorite) in
                if isFavorite != vocabulary.isFavorite {
                    print("Value did change")
                }
            }.store(in: &cancellables)
            return cellViewModel
        })
        tableSections[SectionType.main.rawValue].cells.value = cellViewModels
    }
    
}


