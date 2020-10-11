//
//  MainViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol NavigatableViewModelProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol { get }
}

protocol MainViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

protocol MainViewModelOutputProtocol {
    func fetchData()
    func refreshData(completion: @escaping () -> Void)
}

final class MainViewModel: UniversalCollectionViewViewModel {
    
    // MARK: - Public properties
    
    var tableSections: [CollectionSectionViewModelProtocol]
    
    // MARK: - Private properties
    
    private let router: MainNavigationProtocol
    private let userInfo: UserInfoProtocol
    private let firebaseDatabase: FirebaseDatabaseFetchingProtocol
    private var vocabularies: [Vocabulary]
    
    private enum SectionType: Int {
        case vocabulary
    }
    
    // MARK: - Init
    
    init(router: MainNavigationProtocol,
         userInfo: UserInfoProtocol,
         firebaseDatabase: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.userInfo = userInfo
        self.firebaseDatabase = firebaseDatabase
        self.vocabularies = []
        self.tableSections = []
        
        setupVocabularySection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabularyStatistic(vocabulary)
    }
    
    // MARK: - Private methods
    
    private func setupVocabularySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        let sectionViewModel = SearchBarCollectionReusableViewModel(textDidChange: searchVocabularyByName,
                                                                    didFiter: didFilterTouched,
                                                                    didCancle: didCancelTouched)
        tableSections.append(UniversalCollectionSectionViewModel(sectionViewModel: sectionViewModel, cells: []))
    }
    
    // MARK: - Action
    
    private func fetchData(completion: (() -> Void)?) {
        defer {
            completion?()
        }
        
        guard let userId = userInfo.userId else { return }
        
        let request = VocabularyFetchRequest(userId: userId)
        firebaseDatabase.fetch(request: request) { (result: Result<[Vocabulary], Error>) in
            switch result {
            case .success(let vocabularies):
                self.tableSections[SectionType.vocabulary.rawValue].cells = vocabularies.map({
                    VocabularyCollectionViewCellViewModel(vocabulary: $0)
                })
                self.vocabularies = vocabularies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func searchVocabularyByName(searchText: String) {
        let filteredVocabulary = vocabularies.filter({ $0.title.contains(searchText) })
        let cellViewModels = filteredVocabulary.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
    }
    
    private func didFilterTouched() {
        print(#function)
    }
    
    private func didCancelTouched() {
        let cellViewModels = vocabularies.map({ VocabularyCollectionViewCellViewModel(vocabulary: $0) })
        tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
    }
    
    @objc
    private func didCreateNewVocabularyTouched() {
        router.createNewVocabulary()
    }
    
}

// MARK: - MainViewModelInputProtocol

extension MainViewModel: MainViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let createNewVocabularyButtonModel = BarButtonDrivableModel(title: "Create".localize,
                                                                    style: .plain,
                                                                    target: self,
                                                                    selector: #selector(didCreateNewVocabularyTouched))
        return NavigationItemDrivableModel(title: "Maerials".localize,
                                           leftBarButtonDrivableModels: [],
                                           rightBarButtonDrivableModels: [createNewVocabularyButtonModel])
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .systemBackground,
                                   prefersLargeTitles: false)
    }
    
}

// MARK: - MainViewModelOutputProtocol

extension MainViewModel: MainViewModelOutputProtocol {
    
    func fetchData() {
        fetchData(completion: nil)
    }
    
    func refreshData(completion: @escaping () -> Void) {
        fetchData {
            completion()
        }
    }
    
}
