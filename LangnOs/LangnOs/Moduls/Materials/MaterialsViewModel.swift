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
    
}

enum MaterialsViewModelAction {
    case fetchData
    case createVocabulary
}

protocol MaterialsViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<MaterialsViewModelAction, Never> { get }
}

protocol MaterialsViewModelBindingProtocol {
    
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
    
    var actionSubject = PassthroughSubject<MaterialsViewModelAction, Never>()
    var tableSections: [CollectionSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: MaterialsCoordinatorProtocol
    private let dataProvider: DataFacadeFetchingProtocol & DataFacadeCreatingProtocol
    private let securityManager: SecurityManager
    
    private var actionPublisher: AnyPublisher<MaterialsViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    private var cancellables: [AnyCancellable?] = []
    
    private var vocabularies: [Vocabulary] = [] {
        didSet {
            let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
            tableSections[SectionType.vocabulary.rawValue].cells.value = cellViewModels
        }
    }
    
    // MARK: - Init
    
    init(router: MaterialsCoordinatorProtocol,
         dataProvider: DataFacadeFetchingProtocol & DataFacadeCreatingProtocol,
         securityManager: SecurityManager) {
        self.router = router
        self.dataProvider = dataProvider
        self.securityManager = securityManager
        
        self.bindView()
        
        self.setupEmptySection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabulary(vocabulary)
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
            actionPublisher.sink(receiveValue: { [weak self] (action) in
                switch action {
                case .fetchData:
                    self?.fetchData()
                case .createVocabulary:
                    self?.router.navigateToCreateVocabulary { [weak self] vocabulary in
                        self?.createVocabulary(vocabulary)
                    }
                }
            })
        ]
    }
    
    private func setupEmptySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        let sectionViewModel = UniversalCollectionSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func fetchData() {
        guard let userId = securityManager.user?.uid else { return }
        
        let request = VocabularyFetchRequest(userId: userId)
        dataProvider.fetch(request: request) { (resulr: Result<[Vocabulary], Error>) in
            switch resulr {
            case .success(let vocabularies):
                self.vocabularies = vocabularies
            case .failure(let error):
                self.router.showError(error)
            }
        }
    }
    
    private func createVocabulary(_ vocabulary: Vocabulary) {
        guard let userId = securityManager.user?.uid else { return }
        
        let vocabularyWithUserId = Vocabulary(userId: userId,
                                              title: vocabulary.title,
                                              category: vocabulary.category,
                                              words: vocabulary.words)
        
        let request = VocabularyCreateRequest(vocabulary: vocabularyWithUserId)
        dataProvider.create(request: request) { (error) in
            if let error = error {
                self.router.showError(error)
            } else {
                self.vocabularies.append(vocabularyWithUserId)
            }
        }
    }
    
}


