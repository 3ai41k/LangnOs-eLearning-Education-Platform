//
//  MainViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol MainViewModelInputProtocol {
    var navigationItemDrivableModel: DrivableModelProtocol { get }
    var navigationBarDrivableModel: DrivableModelProtocol { get }
}

protocol MainViewModelOutputProtocol {
    func singInAction()
}

final class MainViewModel {
    
    // MARK: - Private properties
    
    private let router: MainNavigationProtocol
    
    // MARK: - Init
    
    init(router: MainNavigationProtocol) {
        self.router = router
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
    
}

// MARK: - FixedCollectionViewInputProtocol

extension MainViewModel: UniversalCollectionViewInputProtocol {
    
    var numberOfItemsInSection: Int {
        5
    }
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol {
        VocabularyCollectionViewCellViewModel()
    }
    
}

// MARK: - MainViewModelOutputProtocol

extension MainViewModel: MainViewModelOutputProtocol {
    
    func singInAction() {
        router.navigateToSingIn()
    }
    
}
