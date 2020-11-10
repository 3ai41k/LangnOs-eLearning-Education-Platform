//
//  AccountCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol AccountNavigationProtocol {
    func navigateToImagePicker(sourceType: UIImagePickerController.SourceType, didImageSelect: @escaping (UIImage) -> Void)
}

typealias AccountCoordinatorProtocol =
    AccountNavigationProtocol &
    AlertPresentableProtocol &
    CoordinatorClosableProtocol

final class AccountCoordinator: Coordinator, AccountCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let userSession = UserSession.shared
        let storage = UserStorage(storage: FirebaseStorage())
        let viewModel = AccountViewModel(router: self,
                                         userSession: userSession,
                                         storage: storage)
        
        let cellFactory = VocabularySettingsCellFactory()
        let viewController = AccountViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        
        self.viewController = viewController
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - CoordinatorClosableProtocol
    
    func close(completion: (() -> Void)?) {
        (parentViewController as? UINavigationController)?.popViewController(animated: true)
        completion?()
    }
    
    // MARK: - AccountNavigationProtocol
    
    func navigateToImagePicker(sourceType: UIImagePickerController.SourceType, didImageSelect: @escaping (UIImage) -> Void) {
        let imagePickerCoordinator = ImagePickerCoordinator(sourceType: sourceType,
                                                            didImageSelect: didImageSelect,
                                                            parentViewController: viewController)
        imagePickerCoordinator.start()
    }
    
}
