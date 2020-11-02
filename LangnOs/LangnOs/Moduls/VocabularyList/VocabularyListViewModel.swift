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
    func fetchData()
}

typealias VocabularyListViewModelProtocol =
    VocabularyListViewModelInputProtocol &
    VocabularyListViewModelOutputProtocol &
    UniversalTableViewModelProtocol

private enum SectionType: Int {
    case vocabulary
}

final class VocabularyListViewModel: VocabularyListViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Favorites".localize
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularyListCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseUpdatingProtocol
    private let userSession: SessionInfoProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(router: VocabularyListCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseUpdatingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.setupVocabularySection(&tableSections)
        
        self.fetchData()
    }
    
    // MARK: - Public methods
    
    func fetchData() {
        guard let userId = userSession.userId else { return }
        
        let request = VocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            self.updateVocabularySection(vocabularies)
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    // MARK: - Private methods
    
    private func setupVocabularySection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func updateVocabularySection(_ vocabularies: [Vocabulary]) {
        let cellViewModels = vocabularies.map({ (vocabulary) in
            AddToFavoriteCellViewModel(vocabulary: vocabulary) { [weak self] isFavorite in
                vocabulary.isFavorite = isFavorite
                self?.updateVocabulary(vocabulary)
            }
        })
        tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
    }
    
    private func updateVocabulary(_ vocabulary: Vocabulary) {
        let request = VocabularyUpdateRequest(vocabulary: vocabulary)
        dataProvider.update(request: request, onSuccess: {
            print("Success")
        }) { (error) in
            self.router.showError(error)
        }
    }
    
}


