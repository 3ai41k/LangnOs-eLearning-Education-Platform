//
//  MaterialsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol MaterialsViewModelInputProtocol {
    var title: CurrentValueSubject<String?, Never> { get }
    var scopeButtonTitles: CurrentValueSubject<[String]?, Never> { get }
}

protocol MaterialsViewModelOutputProtocol {
    func fetchDataAction()
    func createVocabularyAction()
    func searchAction(_ searchedText: String)
    func selectScopeAction(_ index: Int)
}

protocol MaterialsViewModelBindingProtocol {
    var isActivityIndicatorHidden: CurrentValueSubject<Bool, Never> { get }
}

typealias MaterialsViewModelProtocol =
    MaterialsViewModelInputProtocol &
    MaterialsViewModelOutputProtocol &
    MaterialsViewModelBindingProtocol &
    UniversalCollectionViewModel

private enum SectionType: Int {
    case vocabulary
}

final class MaterialsViewModel: MaterialsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: CurrentValueSubject<String?, Never>
    var scopeButtonTitles: CurrentValueSubject<[String]?, Never>
    var isActivityIndicatorHidden: CurrentValueSubject<Bool, Never>
    var tableSections: [CollectionSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: MaterialsCoordinatorProtocol
    private let dataProvider: DataProviderFetchingProtocol
    private let userSession: SessionInfoProtocol
    
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            isActivityIndicatorHidden.value = true
            
            let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
            tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
        }
    }
    
    private let filters = VocabularyFilter.allCases
    private var slectedFilterIndex = 0
    
    // MARK: - Init
    
    init(router: MaterialsCoordinatorProtocol,
         dataProvider: DataProviderFetchingProtocol,
         userSession: SessionInfoProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.title = .init("Materials".localize)
        self.scopeButtonTitles = .init(filters.map({ $0.title }))
        self.isActivityIndicatorHidden = .init(false)
        
        self.setupEmptySection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabulary(vocabulary) {
            self.vocabularies.removeAll(where: { $0 == vocabulary })
        }
    }
    
    // MARK: - Private methods
    
    private func setupEmptySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        let sectionViewModel = UniversalCollectionSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func discardSearch() {
        let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
    }
    
}

// MARK: - MaterialsViewModelOutputProtocol

extension MaterialsViewModel {
    
    func fetchDataAction() {
        guard let userId = userSession.userId else {
            self.vocabularies = .empty
            return
        }
        
        let request = VocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
            self.vocabularies = vocabularies.sorted(by: \.createdDate, using: >)
        }) { (error) in
            self.router.showError(error)
        }
    }
    
    func createVocabularyAction() {
        router.navigateToCreateVocabulary { (vocabulary) in
            self.vocabularies.append(vocabulary)
        }
    }
    
    //
    // Fix this method
    //
    // filterBy.keyPath can not be cust to KeyPath<Vocabulary, String>
    // because \Vocabulary.createdDate id Date type
    //
    
    func searchAction(_ searchedText: String) {
        guard let filterBy = VocabularyFilter(rawValue: slectedFilterIndex), !searchedText.isEmpty else {
            discardSearch()
            return
        }
        
        let cellViewModels = vocabularies.filter { vocabulary in
            guard let keyPathToString = filterBy.keyPath as? KeyPath<Vocabulary, String> else { return  false }
            return vocabulary[keyPath: keyPathToString].contains(searchedText)
        }.map({
            VocabularyCollectionViewCellViewModel(vocabulary: $0)
        })
        
        tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
    }
    
    func selectScopeAction(_ index: Int) {
        slectedFilterIndex = index
    }
    
}


