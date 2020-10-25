//
//  CreateWordCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class CreateWordCellViewModel: VocabularyCellViewModel {
    
    // MARK: - Public properties
    
    override var headerValue: String? {
        word.term
    }
    
    override var footerValue: String? {
        word.definition
    }
    
    override var toolbarDrivableModel: DrivableModelProtocol? {
        let addButton = BarButtonDrivableModel(title: "Add",
                                               style: .plain,
                                               target: self,
                                               selector: #selector(didAddTouch))
        let imageButton = BarButtonDrivableModel(title: "Image",
                                                 style: .plain,
                                                 target: self,
                                                 selector: #selector(didImageTouch))
        return ToolbarDrivableModel(barButtonDrivableModels: [
            addButton, imageButton
        ])
    }
    
    var addHandler: (() -> Void)?
    var imageHandler: (() -> Void)?
    
    var word: Word
    
    // MARK: - Init
    
    init() {
        self.word = .empty
        
        super.init(headerTitle: "Term".localize, footerTitle: "Definition".localize)
    }
    
    // MARK: - Public methods
    
    override func setHeaderValue(_ text: String) {
        word = Word(term: text, definition: word.definition)
    }
    
    override func setFooterValue(_ text: String) {
        word = Word(term: word.term, definition: text)
    }
    
    // MARK: - Actions
    
    @objc
    private func didAddTouch() {
        addHandler?()
    }
    
    @objc
    private func didImageTouch() {
        imageHandler?()
    }
    
}
