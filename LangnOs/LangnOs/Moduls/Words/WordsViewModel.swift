//
//  WordsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol WordsViewModelInputProtocol {
    
}

protocol WordsViewModelOutputProtocol {
    
}

final class WordsViewModel: UniversalTableViewSectionProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [UniversalTableSectionViewModelProtocol]
    
    // MARK: - Private properties
    
    private let words: [Word]
    private let router: WordsNavigationProtocol
    
    // MARK: - Init
    
    init(words: [Word], router: WordsNavigationProtocol) {
        self.words = words
        self.router = router
        self.tableSections = []
        
        setupWordSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupWordSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        let wordTableViewCellViewModels = words.map({ WordTableViewCellViewModel(word: $0) })
        tableSections.append(UniversalTableSectionViewModel(cells: wordTableViewCellViewModels))
    }
    
}

// MARK: - WordsViewModelInputProtocol

extension WordsViewModel: WordsViewModelInputProtocol {
    
}

// MARK: - WordsViewModelOutputProtocol

extension WordsViewModel: WordsViewModelOutputProtocol {
    
}
