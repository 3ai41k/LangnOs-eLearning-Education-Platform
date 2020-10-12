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
    private let speechSynthesizer: SpeakableProtocol
    private let router: AlertPresentableProtocol
    
    // MARK: - Init
    
    init(words: [Word], speechSynthesizer: SpeakableProtocol, router: AlertPresentableProtocol) {
        self.words = words
        self.speechSynthesizer = speechSynthesizer
        self.router = router
        
        self.tableSections = []
        
        setupFlashCardsSection(&tableSections)
    }
    
    // MARK: - Private methods
    
    private func setupFlashCardsSection(_ tableSections: inout [UniversalTableSectionViewModelProtocol]) {
        let cells: [CellViewModelProtocol] = words.map({
            FlashCardTableViewCellViewModel(word: $0, speechSynthesizer: speechSynthesizer) { [weak self] error in
                self?.showError(error)
            }
        })
        tableSections.append(UniversalTableSectionViewModel(cells: cells))
    }
    
    // MARK: - Actions
    
    private func showError(_ error: Error) {
        router.showAlert(title: "Error!",
                         message: error.localizedDescription,
                         actions: [OkAlertAction(handler: { })])
    }
    
}

// MARK: - FlashCardsViewModelInputProtocol

extension FlashCardsViewModel: FlashCardsViewModelInputProtocol {
    
}

// MARK: - FlashCardsViewModelOutputProtocol

extension FlashCardsViewModel: FlashCardsViewModelOutputProtocol {
    
}