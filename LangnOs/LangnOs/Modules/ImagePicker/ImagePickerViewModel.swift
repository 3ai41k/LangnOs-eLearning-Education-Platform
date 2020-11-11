//
//  ImagePickerViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ImagePickerViewModelInputProtocol {
    var sourceType: UIImagePickerController.SourceType { get }
    var allowsEditing: Bool { get }
    var mediaTypes: [String] { get }
}

protocol ImagePickerViewModelOutputProtocol {
    func selectImageAction(_ image: UIImage)
    func closeAction()
}

typealias ImagePickerViewModelProtocol =
    ImagePickerViewModelInputProtocol &
    ImagePickerViewModelOutputProtocol

final class ImagePickerViewModel {
    
    // MARK: - Public properties
    
    var sourceType: UIImagePickerController.SourceType
    
    // MARK: - Private properties
    
    private let router: ImagePickerCoordinatorProtocol
    
    // MARK: - Init
    
    init(router: ImagePickerCoordinatorProtocol, sourceType: UIImagePickerController.SourceType) {
        self.router = router
        self.sourceType = sourceType
    }
    
}

// MARK: - ImagePickerViewModelInputProtocol

extension ImagePickerViewModel: ImagePickerViewModelInputProtocol {
    
    var allowsEditing: Bool {
        true
    }
    
    var mediaTypes: [String] {
        ["public.image"]
    }
    
}

// MARK: - ImagePickerViewModelOutputProtocol

extension ImagePickerViewModel: ImagePickerViewModelOutputProtocol {
    
    func closeAction() {
        router.close()
    }
    
    func selectImageAction(_ image: UIImage) {
        router.selectImage(image)
    }
    
}


