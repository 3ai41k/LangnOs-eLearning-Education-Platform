//
//  VocabularyFilterViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

typealias VocabularyFilterViewModelProtocol =
    NavigatableViewModelProtocol &
    UniversalTableViewModelProtocol

final class VocabularyFilterViewModel: UniversalTableViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularyFilterCoordinatorProtocol
    private var selectedFilter: VocabularyFilter
    private let filters: [VocabularyFilter]
    
    // MARK: - Init
    
    init(router: VocabularyFilterCoordinatorProtocol, selectedFilter: VocabularyFilter) {
        self.router = router
        self.selectedFilter = selectedFilter
        self.filters = VocabularyFilter.allCases
        
        self.setupFilterSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        selectedFilter = filters[indexPath.row]
    }
    
    // MARK: - Private methods
    
    private func setupFilterSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels: [CellViewModelProtocol] = filters.map({
            let cellViewModel = FilterTableViewCellViewModel(filter: $0)
            if $0 == self.selectedFilter {
                cellViewModel.setFocuse()
            }
            return cellViewModel
        })
        tableSections.append(TableSectionViewModel(cells: cellViewModels))
    }
    
    // MARK: - Actions
    
    @objc
    private func didDoneTouch() {
        router.selectVocabularyFilter(selectedFilter)
    }
    
}

// MARK: - NavigatableViewModelProtocol

extension VocabularyFilterViewModel: NavigatableViewModelProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let doneBarButtonDrivableModel = BarButtonDrivableModel(title: "Done".localize,
                                                                style: .done,
                                                                target: self,
                                                                selector: #selector(didDoneTouch))
        return NavigationItemDrivableModel(title: "Filter".localize,
                                    leftBarButtonDrivableModels: [],
                                    rightBarButtonDrivableModels: [doneBarButtonDrivableModel])
    }
    
}


