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

final class MainViewModel: UniversalCollectionViewViewModelProtocol {
    
    // MARK: - Public properties
    
    var reloadData: (() -> Void)?
    
    var backgroundColor: UIColor {
        .lightGray
    }
    
    var numberOfItemsInSection: Int {
        vocabularies.count
    }
    
    // MARK: - Private properties
    
    private let router: MainNavigationProtocol
    private let cloudFirestore: FirebaseDatabaseProtocol
    
    private var vocabularies: [Vocabulary]
    
    // MARK: - Init
    
    init(router: MainNavigationProtocol, cloudFirestore: FirebaseDatabaseProtocol) {
        self.router = router
        self.cloudFirestore = cloudFirestore
        
        self.vocabularies = []
    }
    
    // MARK: - Public methods
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol {
        let vocabulary = vocabularies[indexPath.row]
        return VocabularyCollectionViewCellViewModel(vocabulary: vocabulary)
    }
    
    func didSelectCellAt(indexPath: IndexPath) {
        let vocabulary = vocabularies[indexPath.row]
        router.navigateToVocabularyStatistic(vocabulary)
    }
    
}

// MARK: - MainViewModelInputProtocol

extension MainViewModel: MainViewModelInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        NavigationItemDrivableModel(title: "Hello, -3ai41k-")
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .systemBackground,
                                   prefersLargeTitles: true)
    }
    
    func fetchData() {
        let request = FirebaseDatabaseVocabularyRequest()
        cloudFirestore.fetch(request: request) { (result: Result<[Vocabulary], Error>) in
            switch result {
            case .success(let vocabularies):
                self.vocabularies = vocabularies
                self.reloadData?()
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
