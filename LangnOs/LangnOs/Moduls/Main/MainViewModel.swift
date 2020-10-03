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

final class MainViewModel: UniversalCollectionViewBindingProtocol {
    
    // MARK: - Public properties
    
    var reloadData: (() -> Void)?
    
    // MARK: - Private properties
    
    private let router: MainNavigationProtocol
    private let cloudFirestore: FirebaseDatabaseProtocol
    
    private var cellViewModels: [CellViewModelProtocol]
    
    // MARK: - Init
    
    init(router: MainNavigationProtocol, cloudFirestore: FirebaseDatabaseProtocol) {
        self.router = router
        self.cloudFirestore = cloudFirestore
        
        self.cellViewModels = []
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
                self.cellViewModels = vocabularies.map({
                    VocabularyCollectionViewCellViewModel(vocabulary: $0)
                })
                self.reloadData?()
            case .failure(let error):
                // FIX IT: Add error handling
                print(error)
            }
        }
    }
    
}

// MARK: - FixedCollectionViewInputProtocol

extension MainViewModel: UniversalCollectionViewInputProtocol {
    
    var backgroundColor: UIColor {
        .lightGray
    }
    
    var numberOfItemsInSection: Int {
        cellViewModels.count
    }
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol {
        cellViewModels[indexPath.row]
    }
    
}

// MARK: - MainViewModelOutputProtocol

extension MainViewModel: MainViewModelOutputProtocol {
    
    func singInAction() {
        router.navigateToSingIn()
    }
    
}
