//
//  VocabularyCategoryViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol VocabularyCategoryViewModelInputProtocol {
    
}

protocol VocabularyCategoryViewModelOutputProtocol {
    
}

typealias VocabularyCategoryViewModelProtocol =
    VocabularyCategoryViewModelInputProtocol &
    VocabularyCategoryViewModelOutputProtocol &
    UniversalTableViewModelProtocol

final class VocabularyCategoryViewModel: VocabularyCategoryViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularyCategoryCoordinatorProtocol
    
    // MARK: - Init
    
    init(router: VocabularyCategoryCoordinatorProtocol) {
        self.router = router
        
        self.setupMainSection()
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let category = Category.allCases[indexPath.row]
        router.selectCategory(category)
    }
    
    // MARK: - Private methods
    
    private func setupMainSection() {
        let cellViewModels = Category.allCases.map({
            TextCellViewModel($0.rawValue)
        })
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }

}


