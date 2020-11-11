//
//  VocabularyListViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 28.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyListViewModelInputProtocol {
    var title: String { get }
    var backgroudTitle: String { get }
}

protocol VocabularyListViewModelOutputProtocol {
    
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
    
    var backgroudTitle: String {
        "There aren't any materials.".localize
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularyListCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseUpdatingProtocol
    private let userSession: SessionInfoProtocol
    private let networkState: InternetConnectableProtocol
    
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            var cellViewModels: [CellViewModelProtocol] = []
            for var vocabulary in vocabularies {
                let cellViewModel = AddToFavoriteCellViewModel(vocabulary: vocabulary) { [weak self] isFavorite in
                    vocabulary.isFavorite = isFavorite
                    self?.addToFavorite(vocabulary: vocabulary)
                }
                cellViewModels.append(cellViewModel)
            }
            tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
        }
    }
    
    // MARK: - Init
    
    init(router: VocabularyListCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol & FirebaseDatabaseUpdatingProtocol,
         userSession: SessionInfoProtocol,
         networkState: InternetConnectableProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        self.networkState = networkState
        
        self.appendVocabularySection()
        
        self.fetchData()
    }
    
    // MARK: - Public methods
    
    private func fetchData() {
        guard let userId = userSession.currentUser?.id else { return }
        
        if networkState.isReachable {
            let request = VocabularyFetchRequest(userId: userId)
            dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
                self.vocabularies = vocabularies
            }) { (error) in
                self.router.showError(error)
            }
        } else {
            do {
                vocabularies = try VocabularyEntity.selectAllBy(userId: userId)
            } catch {
                vocabularies = .empty
            }
        }
    }
    
    // MARK: - Private methods
    
    private func appendVocabularySection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func addToFavorite(vocabulary: Vocabulary) {
        if networkState.isReachable {
            let request = VocabularyUpdateRequest(vocabulary: vocabulary)
            dataProvider.update(request: request, onSuccess: {
                self.update(vocabulary: vocabulary)
            }) { (error) in
                self.router.showError(error)
            }
        } else {
            update(vocabulary: vocabulary)
        }
    }
    
    private func update(vocabulary: Vocabulary) {
        try? VocabularyEntity.update(entity: vocabulary)
        vocabulary.isFavorite ?
            self.router.addFavaoriteVocabulary(vocabulary) :
            self.router.removeFavaoriteVocabulary(vocabulary)
    }
    
}


