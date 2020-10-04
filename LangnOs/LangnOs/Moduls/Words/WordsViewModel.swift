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

final class WordsViewModel: UniversalTableViewViewModel {
    
    // MARK: - Public properties
    
    var numberOfRows: Int {
        words.count
    }
    
    // MARK: - Private properties
    
    private let words: [Word]
    private let router: WordsNavigationProtocol
    
    // MARK: - Init
    
    init(words: [Word], router: WordsNavigationProtocol) {
        self.words = words
        self.router = router
    }
    
    // MARK: - Public methods
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol {
        let word = words[indexPath.row]
        return WordTableViewCellViewModel(word: word)
    }
    
}

// MARK: - WordsViewModelInputProtocol

extension WordsViewModel: WordsViewModelInputProtocol {
    
}

// MARK: - WordsViewModelOutputProtocol

extension WordsViewModel: WordsViewModelOutputProtocol {
    
}
