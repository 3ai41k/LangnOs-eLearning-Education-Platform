//
//  ImagePickerViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ImagePickerViewController: UIImagePickerController {
    
    // MARK: - Public properties
    
    var viewModel: ImagePickerViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateComponents()
    }
    
    // MARK: - Private methods
    
    private func configurateComponents() {
        delegate = self
        
        guard let viewModel = viewModel else { return }
        
        sourceType = viewModel.sourceType
        allowsEditing = viewModel.allowsEditing
        mediaTypes = viewModel.mediaTypes
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePickerViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel?.closeAction()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard
            let info = info[.editedImage] ?? info[.originalImage],
            let image = info as? UIImage
        else {
            viewModel?.closeAction()
            return
        }
        viewModel?.selectImageAction(image)
    }
    
}

// MARK: - UINavigationControllerDelegate

extension ImagePickerViewController: UINavigationControllerDelegate {
    
}

