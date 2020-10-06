//
//  MainViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol MainViewModelInputProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol { get }
    func fetchData()
}

protocol MainViewModelOutputProtocol {
    func singInAction()
}

final class MainViewModel: UniversalCollectionViewViewModel {
    
    // MARK: - Public properties
    
    var tableSections: [TableSectionViewModelProtocol] = [
        UniversalTableSectionViewModel(title: nil, cells: [])
    ]
    
    // MARK: - Private properties
    
    private let router: MainNavigationProtocol
    private let firebaseDatabase: FirebaseDatabaseFetchingProtocol
    private var vocabularies: [Vocabulary]
    
    private enum SectionType: Int {
        case vocabulary
    }
    
    // MARK: - Init
    
    init(router: MainNavigationProtocol, firebaseDatabase: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.firebaseDatabase = firebaseDatabase
        self.vocabularies = []
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabularyStatistic(vocabulary)
    }
    
    // MARK: - Actions
    
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
    
    func fetchData() {
        let request = VocabularyFetchRequest()
        firebaseDatabase.fetch(request: request) { (result: Result<[Vocabulary], Error>) in
            switch result {
            case .success(let vocabularies):
                let cellViewModels = vocabularies
                    //.sorted(by: { $0.createdDate > $1.createdDate })
                    .map({
                        VocabularyCollectionViewCellViewModel(vocabulary: $0)
                    })
                
                self.tableSections[SectionType.vocabulary.rawValue].cells = cellViewModels
                self.vocabularies = vocabularies
            case .failure(let error):
                // FIX IT: Add error handling
                print(error)
            }
        }
    }
    
}

// MARK: - MainViewModelOutputProtocol

extension MainViewModel: MainViewModelOutputProtocol {
    
    func singInAction() {
        router.navigateToSingIn()
    }
    
}
