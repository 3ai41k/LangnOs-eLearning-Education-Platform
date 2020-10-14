//
//  FilterTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol FilterTableViewCellViewModelInputProtocol {
    var title: String { get }
    var image: UIImage? { get }
}

protocol FilterTableViewCellViewModelOutputProtocol {
    
}

protocol FilterTableViewCellViewModelBindingProtocol {
    
}

typealias FilterTableViewCellViewModelProtocol =
    FilterTableViewCellViewModelInputProtocol &
    FilterTableViewCellViewModelOutputProtocol &
    FilterTableViewCellViewModelBindingProtocol

final class FilterTableViewCellViewModel: FilterTableViewCellViewModelBindingProtocol, CellViewModelProtocol {
    
    // MARK: - Public properties
    
    
    
    // MARK: - Private properties
    
    private let vocabularyFilter: VocabularyFilter
    
    // MARK: - Init
    
    init(vocabularyFilter: VocabularyFilter) {
        self.vocabularyFilter = vocabularyFilter
    }
    
    // MARK: - Public methods
    
    
    
    // MARK: - Private methods
    
    
    
}

// MARK: - FilterTableViewCellViewModelInputProtocol

extension FilterTableViewCellViewModel: FilterTableViewCellViewModelInputProtocol {
    
    var title: String {
        vocabularyFilter.name
    }
    
    var image: UIImage? {
        nil
    }
    
}

// MARK: - FilterTableViewCellViewModelOutputProtocol

extension FilterTableViewCellViewModel: FilterTableViewCellViewModelOutputProtocol {
    
}


