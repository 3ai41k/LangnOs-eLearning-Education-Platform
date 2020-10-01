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
    
}

final class MainViewModel { }

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

// MARK: - MainViewModelOutputProtocol

extension MainViewModel: MainViewModelOutputProtocol {
    
}
