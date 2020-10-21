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
    var accessoryType: UITableViewCell.AccessoryType { get }
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
    
    var accessoryType: UITableViewCell.AccessoryType = .none
    
    // MARK: - Private properties
    
    private let filter: VocabularyFilter
    
    // MARK: - Init
    
    init(filter: VocabularyFilter) {
        self.filter = filter
    }
    
    // MARK: - Public methods
    
    func setFocuse() {
        accessoryType = .checkmark
    }
    
    // MARK: - Private methods
    
    
    
}

// MARK: - FilterTableViewCellViewModelInputProtocol

extension FilterTableViewCellViewModel: FilterTableViewCellViewModelInputProtocol {
    
    var title: String {
        filter.title
    }
    
    var image: UIImage? {
        nil
    }
    
}

// MARK: - FilterTableViewCellViewModelOutputProtocol

extension FilterTableViewCellViewModel: FilterTableViewCellViewModelOutputProtocol {
    
}


