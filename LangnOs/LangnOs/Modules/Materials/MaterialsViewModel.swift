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
    var title: String { get }
    var scopeButtonTitles: [String] { get }
}

protocol MaterialsViewModelOutputProtocol {
    func createVocabulary()
    func search(_ text: String)
    func selectScope(_ index: Int)
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
    
    var title: String {
        "Materials".localize
    }
    
    var scopeButtonTitles: [String] {
        filters.map({ $0.title })
    }
    
    var isActivityIndicatorHidden: CurrentValueSubject<Bool, Never>
    var tableSections: [CollectionSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: MaterialsCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    private let userSession: SessionInfoProtocol
    private let networkState: InternetConnectableProtocol
    
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
         dataProvider: FirebaseDatabaseFetchingProtocol,
         userSession: SessionInfoProtocol,
         networkState: InternetConnectableProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        self.networkState = networkState
        
        self.isActivityIndicatorHidden = .init(false)
        
        self.setupEmptySection()
        
        self.fetchData()
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabulary(vocabulary) {
            self.vocabularies.removeAll(where: { $0 == vocabulary })
        }
    }
    
    func createVocabulary() {
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
    
    func search(_ text: String) {
        guard let filterBy = VocabularyFilter(rawValue: slectedFilterIndex), !text.isEmpty else {
            discardSearch()
            return
        }
        
        let cellViewModels = vocabularies.filter { vocabulary in
            guard let keyPathToString = filterBy.keyPath as? KeyPath<Vocabulary, String> else { return  false }
            return vocabulary[keyPath: keyPathToString].contains(text)
        }.map({
            VocabularyCollectionViewCellViewModel(vocabulary: $0)
        })
        
        tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
    }
    
    func selectScope(_ index: Int) {
        slectedFilterIndex = index
    }
    
    func refreshData(completion: @escaping () -> Void) {
        fetchData()
        completion()
    }
    
    // MARK: - Private methods
    
    private func setupEmptySection() {
        let sectionViewModel = UniversalCollectionSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func discardSearch() {
        let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
    }
    
    private func fetchData() {
        guard let userId = userSession.currentUser?.id else {
            vocabularies = .empty
            return
        }
        
        if networkState.isReachable {
            let request = VocabularyFetchRequest(userId: userId)
            dataProvider.fetch(request: request, onSuccess: { (vocabularies: [Vocabulary]) in
                vocabularies.forEach({ try? VocabularyEntity.insert(entity: $0) })
                self.vocabularies = vocabularies
            }) { (error) in
                self.vocabularies = .empty
            }
        } else {
            do {
                vocabularies = try VocabularyEntity.selectAllBy(userId: userId)
            } catch {
                vocabularies = .empty
            }
        }
    }
    
}

