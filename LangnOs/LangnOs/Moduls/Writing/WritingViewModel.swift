//
//  WritingViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 18.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol WritingViewModelInputProtocol {
    var word: CurrentValueSubject<String?, Never> { get }
    var isAnswerHidden: CurrentValueSubject<Bool, Never> { get }
    var message: CurrentValueSubject<(String, UIColor)?, Never> { get }
    var clearInputPublisher: AnyPublisher<Void, Never> { get }
}

enum WritingViewModelAction {
    case check(String)
    case answer
}

protocol WritingViewModelOutputProtocol {
    var actionSubject: PassthroughSubject<WritingViewModelAction, Never> { get }
}

typealias WritingViewModelProtocol =
    WritingViewModelInputProtocol &
    WritingViewModelOutputProtocol

final class WritingViewModel: WritingViewModelProtocol {
    
    // MARK: - Public properties
    
    var word: CurrentValueSubject<String?, Never>
    var isAnswerHidden: CurrentValueSubject<Bool, Never>
    var message: CurrentValueSubject<(String, UIColor)?, Never>
    var clearInputPublisher: AnyPublisher<Void, Never> {
        clearInputSubject.eraseToAnyPublisher()
    }
    var actionSubject: PassthroughSubject<WritingViewModelAction, Never>
    
    // MARK: - Private properties
    
    private let words: [Word]
    private var currentWord: Word {
        didSet {
            word.value = currentWord.term
        }
    }
    private var mistakeCounter: Int {
        didSet {
            if mistakeCounter == 2 {
                isAnswerHidden.value = false
            }
        }
    }
    
    private var clearInputSubject: PassthroughSubject<Void, Never>
    private var actionPublisher: AnyPublisher<WritingViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    private var cancellables: [AnyCancellable?]
    
    // MARK: - Init
    
    init(words: [Word]) {
        self.words = words
        self.currentWord = words.randomElement()!
        self.mistakeCounter = 0
        
        self.word = .init(currentWord.term)
        self.message = .init(nil)
        self.isAnswerHidden = .init(true)
        self.clearInputSubject = .init()
        self.actionSubject = .init()
        self.cancellables = []
        
        self.bindView()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        cancellables = [
            actionPublisher.sink(receiveValue: { [weak self] action in
                switch action {
                case .check(let text):
                    self?.checkUserInput(text)
                case .answer:
                    self?.showAnswer()
                }
            })
        ]
    }
    
    // MARK: - Actions
    
    private func checkUserInput(_ string: String) {
        if string.lowercased() == currentWord.definition.lowercased() {
            currentWord = words.randomElement()!
            message.value = ("Correct!", .green)
            isAnswerHidden.value = true
            mistakeCounter = 0
            clearInputSubject.send()
        } else {
            message.value = ("Incorrect!", .red)
            mistakeCounter += 1
        }
    }
    
    private func showAnswer() {
        word.value = currentWord.definition
    }
    
}


