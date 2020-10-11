//
//  FlashCardsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol FlashCardsViewModelInputProtocol {
    
}

protocol FlashCardsViewModelOutputProtocol {
    
}

typealias FlashCardsViewModelProtocol = UniversalTableViewSectionProtocol & FlashCardsViewModelInputProtocol & FlashCardsViewModelOutputProtocol

final class FlashCardsViewModel: UniversalTableViewSectionProtocol {
    
    // MARK: - Public properties
    
    var tableSections: [UniversalTableSectionViewModelProtocol]
    
    // MARK: - Private properties

    private let words: [Word]
    
    // MARK: - Init
    
    init(words: [Word]) {
        self.words = words
        self.tableSections = []
        
        setupFlashCardsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupFlashCardsSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        let cells: [CellViewModelProtocol] = words.map({ FlashCardTableViewCellViewModel(word: $0) })
        tableSections.append(UniversalTableSectionViewModel(cells: cells))
    }
    
}

// MARK: - FlashCardsViewModelInputProtocol

extension FlashCardsViewModel: FlashCardsViewModelInputProtocol {
    
}

// MARK: - FlashCardsViewModelOutputProtocol

extension FlashCardsViewModel: FlashCardsViewModelOutputProtocol {
    
}
