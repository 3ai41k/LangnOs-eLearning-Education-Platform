//
//  VocabularyFilterViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyFilterViewModelInputProtocol: NavigatableViewModelProtocol {
    
}

protocol VocabularyFilterViewModelOutputProtocol {
    
}

protocol VocabularyFilterViewModelBindingProtocol {
    
}

typealias VocabularyFilterViewModelProtocol =
    VocabularyFilterViewModelInputProtocol &
    VocabularyFilterViewModelOutputProtocol &
    VocabularyFilterViewModelBindingProtocol &
    UniversalTableViewModelProtocol

final class VocabularyFilterViewModel: VocabularyFilterViewModelBindingProtocol, UniversalTableViewModelProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [UniversalTableSectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: VocabularyFilterCoordinatorProtocol
    
    // MARK: - Init
    
    init(router: VocabularyFilterCoordinatorProtocol) {
        self.router = router
        
        setupFilterSection(&tableSections)
    }
    
    // MARK: - Public methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        
    }
    
    // MARK: - Private methods
    
    private func setupFilterSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        tableSections.append(UniversalTableSectionViewModel(cells: []))
    }
    
    // MARK: - Actions
    
    @objc
    private func didDoneTouch() {
        
    }
    
}

// MARK: - VocabularyFilterViewModelInputProtocol

extension VocabularyFilterViewModel: VocabularyFilterViewModelInputProtocol {
    
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

// MARK: - VocabularyFilterViewModelOutputProtocol

extension VocabularyFilterViewModel: VocabularyFilterViewModelOutputProtocol {
    
}


