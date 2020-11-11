//
//  UniversalCollectionSectionViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

final class UniversalCollectionSectionViewModel: CollectionSectionViewModelProtocol {
    
    // MARK: - Public properties
    
    var sectionHeaderViewModel: CollectionReusableViewModelProtocol?
    var sectionFooterViewModel: CollectionReusableViewModelProtocol?
    var cells: CurrentValueSubject<[CellViewModelProtocol], Never>
    
    // MARK: - Init
    
    init(sectionHeaderViewModel: CollectionReusableViewModelProtocol? = nil,
         sectionFooterViewModel: CollectionReusableViewModelProtocol? = nil,
         cells: [CellViewModelProtocol]) {
        self.sectionHeaderViewModel = sectionHeaderViewModel
        self.sectionFooterViewModel = sectionFooterViewModel
        self.cells = .init(cells)
    }
    
}
