//
//  TableSectionViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

final class TableSectionViewModel: SectionViewModelProtocol {
    
    // MARK: - Public properties
    
    var sectionHeaderViewModel: SectionViewViewModelProtocol?
    var sectionFooterViewModel: SectionViewViewModelProtocol?
    var cells: CurrentValueSubject<[CellViewModelProtocol], Never>
    
    // MARK: - Init
    
    init(headerView: SectionViewViewModelProtocol? = nil,
         footerView: SectionViewViewModelProtocol? = nil,
         cells: [CellViewModelProtocol]) {
        self.sectionHeaderViewModel = headerView
        self.sectionFooterViewModel = footerView
        self.cells = .init(cells)
    }
    
}
