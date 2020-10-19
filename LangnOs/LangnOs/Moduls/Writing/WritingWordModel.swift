//
//  WritingWordModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 19.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

class WritingWord {
    
    // MARK: - Public properties
    
    var term: String {
        word.term
    }
    
    var definition: String {
        word.definition
    }
    
    var isLearned: Bool {
        correctCounter == 2
    }
    
    var isFailed: Bool {
        mistakeCounter == 2
    }
    
    private(set) var correctCounter: Int
    
    // MARK: - Private properties
    
    private let word: Word
    private var mistakeCounter: Int
    
    // MARK: - Init
    
    init(word: Word) {
        self.word = word
        self.correctCounter = 0
        self.mistakeCounter = 0
    }
    
    // MARK: - Public methods
    
    func markCorrect() {
        if mistakeCounter == 0 && correctCounter < 2 {
            correctCounter += 1
        } else {
            correctCounter = 0
            mistakeCounter = 0
        }
    }
    
    func markIncorrect() {
        if correctCounter != 0 {
            correctCounter -= 1
        }
        
        if mistakeCounter < 2 {
            mistakeCounter += 1
        }
    }
    
}
