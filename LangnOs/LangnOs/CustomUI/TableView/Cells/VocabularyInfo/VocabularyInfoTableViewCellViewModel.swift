//
//  VocabularyInfoTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyInfoTableViewCellViewModelProtocol: CellViewModelProtocol, ResignibleRespondersProtocol {
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

protocol VocabularyInfoViewCellBindingProtocol {
    var resignFirstResponders: (() -> Void)? { get set }
}

final class VocabularyInfoTableViewCellViewModel: VocabularyInfoTableViewCellViewModelProtocol, VocabularyInfoViewCellInputProtocol, VocabularyInfoViewCellBindingProtocol {
    
    // MARK: - Public properties
    
    var name: String
    var category: String
    var resignFirstResponders: (() -> Void)?
    
    // MARK: - Init
    
    init() {
        self.name = ""
        self.category = ""
    }
    
    // MARK: - Public methods
    
    func resignResponders() {
        resignFirstResponders?()
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
