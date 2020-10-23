//
//  MaterialsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol MaterialsViewModelInputProtocol {
    
}

protocol MaterialsViewModelOutputProtocol {
    
}

protocol MaterialsViewModelBindingProtocol {
    
}

typealias MaterialsViewModelProtocol =
    MaterialsViewModelInputProtocol &
    MaterialsViewModelOutputProtocol &
    MaterialsViewModelBindingProtocol &
    UniversalCollectionViewModel

final class MaterialsViewModel: MaterialsViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [CollectionSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    
    
    // MARK: - Init
    
    init() {
        self.setupEmptySection(&tableSections)
    }
    
    // MARK: - Public methods
    
    
    
    // MARK: - Private methods
    
    private func setupEmptySection(_ tableSections: inout [CollectionSectionViewModelProtocol]) {
        let sectionViewModel = UniversalCollectionSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
}


