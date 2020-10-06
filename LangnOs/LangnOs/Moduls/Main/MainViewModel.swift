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
    private let cloudFirestore: FirebaseDatabaseFetchingProtocol
    private var vocabularies: [Vocabulary]
    
    private enum SectionType: Int {
        case vocabulary
    }
    
    // MARK: - Init
    
    init(router: MainNavigationProtocol, cloudFirestore: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.cloudFirestore = cloudFirestore
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
        let request = FirebaseDatabaseVocabularyFetchRequest()
        cloudFirestore.fetch(request: request) { (result: Result<[Vocabulary], Error>) in
            switch result {
            case .success(let vocabularies):
                self.vocabularies = vocabularies
                self.tableSections[SectionType.vocabulary.rawValue].cells = vocabularies.map({
                    VocabularyCollectionViewCellViewModel(vocabulary: $0)
                })
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
