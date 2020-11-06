//
//  WordRepresentionCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 25.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class WordRepresentionCellViewModel: VocabularyCellViewModel {
    
    // MARK: - Public properties
    
    override var headerValue: String? {
        word.term
    }
    
    override var footerValue: String? {
        word.definition
    }
    
    var word: Word
    
    // MARK: - Private properties
    
    private let mediaDownloader: MediaDownloadableProtocol
    
    // MARK: - Init
    
    init(word: Word, mediaDownloader: MediaDownloadableProtocol) {
        self.word = word
        self.mediaDownloader = mediaDownloader
        
        super.init(headerTitle: "Term".localize, footerTitle: "Definition".localize)
        
        self.isEditable.value = false
        
        self.downloadPhoto()
    }
    
    // MARK: - Override methods
    
    override func setHeaderValue(_ text: String) {
        word = Word(term: text, definition: word.definition)
    }
    
    override func setFooterValue(_ text: String) {
        word = Word(term: word.term, definition: text)
    }
    
    // MARK: - Private methods
    
    private func downloadPhoto() {
        guard let photURL = word.photoURL else { return }
        showActivity.value = true
        
        mediaDownloader.downloadMedia(url: photURL, onSucces: { (data) in
            self.showActivity.value = false
            self.image.value = UIImage(data: data)?.resized(to: CGSize(width: 256.0, height: 210.0))
        }) { (error) in
            self.showActivity.value = false
            print(error.localizedDescription)
        }
    }
    
}
