//
//  CreateWordCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

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
    var imageHandler: ((@escaping (UIImage) -> Void) -> Void)?
    
    private(set) var word: Word
    
    // MARK: - Private properties
    
    private let storage: FirebaseStorageUploadingProtocol
    
    // MARK: - Init
    
    init(storage: FirebaseStorageUploadingProtocol) {
        self.storage = storage
        self.word = .empty
        
        super.init(headerTitle: "Term".localize, footerTitle: "Definition".localize)
    }
    
    // MARK: - Override methods
    
    override func setHeaderValue(_ text: String) {
        word.term = text
    }
    
    override func setFooterValue(_ text: String) {
        word.definition = text
    }
    
    // MARK: - Public methods
    
    func uploadImage(userId: String, vocabularyId: String, dispatchGroup: DispatchGroup) {
        guard let image = image.value, let data = image.jpegData(compressionQuality: 0.25) else { return }
        
        let request = UploadTermImageRequest(userId: userId,
                                             vocabularyId: vocabularyId,
                                             imageName: word.term,
                                             imageData: data)
        
        dispatchGroup.enter()
        storage.upload(request: request, onSuccess: { (photoURL) in
            dispatchGroup.leave()
        }) { (error) in
            print(error.localizedDescription)
            dispatchGroup.leave()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didAddTouch() {
        addHandler?()
    }
    
    @objc
    private func didImageTouch() {
        imageHandler? { (image) in
            self.image.value = image.resized(to: CGSize(width: 256, height: 210))
        }
    }
    
}
