//
//  VocabularyInfoTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol VocabularyInfoTableViewCellViewModelProtocol: CellViewModelProtocol, ResignibleRespondersProtocol {
    var vocabularyName: String { get }
}

protocol VocabularyInfoViewCellInputProtocol {
    var title: String { get }
}

protocol VocabularyInfoViewCellOutputProtocol {
    func setTitle(_ title: String)
}

protocol VocabularyInfoViewCellBindingProtocol {
    var resignFirstResponders: (() -> Void)? { get set }
}

final class VocabularyInfoTableViewCellViewModel: VocabularyInfoTableViewCellViewModelProtocol, VocabularyInfoViewCellBindingProtocol {
    
    // MARK: - Public properties
    
    var vocabularyName: String
    var resignFirstResponders: (() -> Void)?
    
    // MARK: - Init
    
    init() {
        self.vocabularyName = ""
    }
    
    // MARK: - Public methods
    
    func resignResponders() {
        resignFirstResponders?()
    }
    
}

// MARK: - VocabularyInfoViewCellInputProtocol

extension VocabularyInfoTableViewCellViewModel: VocabularyInfoViewCellInputProtocol {
    
    var title: String {
        vocabularyName
    }
    
}

// MARK: - VocabularyInfoViewCellInputProtocol

extension VocabularyInfoTableViewCellViewModel: VocabularyInfoViewCellOutputProtocol {
    
    func setTitle(_ title: String) {
        self.vocabularyName = title
    }
    
}
