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

protocol SearchVocabularyCellOutputProtocol {
    func save()
}

typealias SearchVocabularyCellProtocol =
    SearchVocabularyCellInputProtocol &
    SearchVocabularyCellOutputProtocol &
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
    private let userSession: SessionInfoProtocol
    private let saveHandler: () -> Void
    
    // MARK: - Init
    
    init(vocabulary: Vocabulary,
         storage: FirebaseStorageFetchingProtocol,
         userSession: SessionInfoProtocol,
         saveHandler: @escaping () -> Void) {
        self.vocabulary = vocabulary
        self.storage = storage
        self.userSession = userSession
        self.saveHandler = saveHandler
        
        self.image = .init(nil)
        
        self.downloadUserPhoto()
    }
    
    // MARK: - Public methods
    
    func save() {
        saveHandler()
    }
    
    // MARK: - Private methods
    
    private func downloadUserPhoto() {
        guard let currentUser = userSession.currentUser, currentUser.photoURL != nil else {
            image.value = SFSymbols.personCircle()
            return
        }
        
        let request = FetchUserImageRequest(userId: currentUser.id)
        storage.fetch(request: request, onSuccess: { (image) in
            self.image.value = image
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
