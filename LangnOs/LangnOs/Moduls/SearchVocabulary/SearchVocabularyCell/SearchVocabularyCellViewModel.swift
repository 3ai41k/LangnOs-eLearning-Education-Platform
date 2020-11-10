//
//  SeachVocabularyCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 10.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol SearchVocabularyCellInputProtocol {
    var name: String { get }
    var terms: String { get }
    var image: CurrentValueSubject<UIImage?, Never> { get }
}

typealias SearchVocabularyCellProtocol =
    SearchVocabularyCellInputProtocol &
    CellViewModelProtocol

final class SearchVocabularyCellViewModel: SearchVocabularyCellProtocol {
    
    // MARK: - Public properties
    
    var name: String {
        vocabulary.title
    }
    
    var terms: String {
        String(vocabulary.words.count) + " terms".localize
    }
    
    var image: CurrentValueSubject<UIImage?, Never>
    
    // MARK: - Private properties
    
    private let vocabulary: Vocabulary
    private let storage: FirebaseStorageFetchingProtocol
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary,
         storage: FirebaseStorageFetchingProtocol) {
        self.vocabulary = vocabulary
        self.storage = storage
        
        self.image = .init(nil)
        
        self.downloadUserPhoto()
    }
    
    // MARK: - Private methods
    
    private func downloadUserPhoto() {
        let request = FetchUserImageRequest(userId: vocabulary.userId)
        storage.fetch(request: request, onSuccess: { (image) in
            self.image.value = image
        }) { (error) in
            self.image.value = SFSymbols.personCircle()
            print(error)
        }
    }
    
}
