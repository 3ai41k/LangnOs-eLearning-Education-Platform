//
//  ImagePickerCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ImagePickerCoordinatorNavigationProtocol {
    func selectImage(_ image: UIImage)
}

typealias ImagePickerCoordinatorProtocol =
    ImagePickerCoordinatorNavigationProtocol &
    CoordinatorClosableProtocol

final class ImagePickerCoordinator: Coordinator, ImagePickerCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let sourceType: UIImagePickerController.SourceType
    private let didImageSelect: (UIImage) -> Void
    
    // MARK: - Init
    
    init(sourceType: UIImagePickerController.SourceType,
         didImageSelect: @escaping (UIImage) -> Void,
         parentViewController: UIViewController?) {
        self.sourceType = sourceType
        self.didImageSelect = didImageSelect
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = ImagePickerViewModel(router: self, sourceType: sourceType)
        let viewController = ImagePickerViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - ImagePickerCoordinatorNavigationProtocol
    
    func selectImage(_ image: UIImage) {
        close {
            self.didImageSelect(image)
        }
    }
    
}




