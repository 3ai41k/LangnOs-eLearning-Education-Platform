//
//  FlashCardTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol FlashCardTableViewCellInputProtocol {
    var header: CurrentValueSubject<String?, Never> { get }
    var term: CurrentValueSubject<String?, Never> { get }
    var isPronounceButtonEnabled: CurrentValueSubject<Bool, Never> { get }
    var flipPublisher: AnyPublisher<Void, Never> { get }
}

protocol FlashCardTableViewCellOutputProtocol {
    func flip()
    func pronaunce()
}

typealias FlashCardCellViewModelProtocol =
    FlashCardTableViewCellInputProtocol &
    FlashCardTableViewCellOutputProtocol
    
final class FlashCardTableViewCellViewModel: CellViewModelProtocol, FlashCardCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var header: CurrentValueSubject<String?, Never>
    var term: CurrentValueSubject<String?, Never>
    var isPronounceButtonEnabled: CurrentValueSubject<Bool, Never>
    var flipPublisher: AnyPublisher<Void, Never> {
        flipSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private properties
    
    private let word: Word
    private let speechSynthesizer: SpeakableProtocol
    private let onErrorHandler: (Error) -> Void
    
    private var isFipped = false
    private var flipSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    init(word: Word,
         speechSynthesizer: SpeakableProtocol,
         onErrorHandler: @escaping (Error) -> Void) {
        self.word = word
        self.speechSynthesizer = speechSynthesizer
        self.onErrorHandler = onErrorHandler
        
        self.header = .init("Term".localize)
        self.term = .init(word.term)
        self.isPronounceButtonEnabled = .init(true)
    }
    
    // MARK: - FlashCardTableViewCellOutputProtocol
    
    func flip() {
        flipSubject.send()
        isFipped = isFipped ? false : true
        header.value = isFipped ? "Definition".localize : "Term".localize
        term.value = isFipped ? word.definition : word.term
    }
    
    func pronaunce() {
        speechSynthesizer.didStartHandler = { [weak self] in
            self?.isPronounceButtonEnabled.value = false
        }
        speechSynthesizer.didFinishHandler = { [weak self] in
            self?.isPronounceButtonEnabled.value = true
        }
        do {
            try speechSynthesizer.speak(string: term.value!)
        } catch {
            onErrorHandler(error)
        }
    }
    
}
