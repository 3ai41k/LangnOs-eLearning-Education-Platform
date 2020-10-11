//
//  VocabularyInfoTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyInfoTableViewCellViewModelProtocol: CellViewModelProtocol {
    var name: String { get }
    var category: String { get }
}

protocol VocabularyInfoViewCellInputProtocol {
    var name: String { get }
    var category: String { get }
}

protocol VocabularyInfoViewCellOutputProtocol {
    func setName(_ name: String)
    func setCategory(_ category: String)
}

final class VocabularyInfoTableViewCellViewModel: VocabularyInfoTableViewCellViewModelProtocol, VocabularyInfoViewCellInputProtocol {
    
    // MARK: - Public properties
    
    var name: String
    var category: String
    
    // MARK: - Init
    
    init() {
        self.name = ""
        self.category = ""
    }
    
}

// MARK: - VocabularyInfoViewCellInputProtocol

extension VocabularyInfoTableViewCellViewModel: VocabularyInfoViewCellOutputProtocol {
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func setCategory(_ category: String) {
        self.category = category
    }
    
}
