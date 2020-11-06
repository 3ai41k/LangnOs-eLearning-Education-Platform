//
//  CreateVocabularyCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CreateVocabularyNavigationProtocol: CoordinatorClosableProtocol {
    func didCreateVocabulary(_ vocabulary: Vocabulary)
    func showCategoryPopover(sourceView: UIView, didCategorySelect: @escaping (Category) -> Void)
    func navigateToImagePicker(sourceType: UIImagePickerController.SourceType, didImageSelect: @escaping (UIImage) -> Void)
}

typealias CreateVocabularyCoordinatorProtocol =
    CreateVocabularyNavigationProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class CreateVocabularyCoordinator: Coordinator, CreateVocabularyCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let createHandler: (Vocabulary) -> Void
    
    // MARK: - Init
    
    init(createHandler: @escaping (Vocabulary) -> Void,
         parentViewController: UIViewController?) {
        self.createHandler = createHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let firebaseDatabase = FirebaseDatabase.shared
        let dataProvider = DataProvider(firebaseDatabase: firebaseDatabase)
        let storage = FirebaseStorage()
        let userSession = UserSession.shared
        let viewModel = CreateVocabularyViewModel(router: self,
                                                  dataProvider: dataProvider,
                                                  storage: storage,
                                                  userSession: userSession)
        
        let cellFactory = CreateVocabularyCellFactory()
        let viewController = CreateVocabularyViewController()
        viewController.cellFactory = cellFactory
        viewController.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.viewController = navigationController
        parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - CreateVocabularyNavigationProtocol
    
    func didCreateVocabulary(_ vocabulary: Vocabulary) {
        close {
            self.createHandler(vocabulary)
        }
    }
    
    func showCategoryPopover(sourceView: UIView, didCategorySelect: @escaping (Category) -> Void) {
        let vocabularyCategoryCoordinator = VocabularyCategoryCoordinator(sourceView: sourceView,
                                                                          didCategorySelect: didCategorySelect,
                                                                          parentViewController: viewController)
        vocabularyCategoryCoordinator.start()
    }
    
    func navigateToImagePicker(sourceType: UIImagePickerController.SourceType, didImageSelect: @escaping (UIImage) -> Void) {
        let imagePickerCoordinator = ImagePickerCoordinator(sourceType: sourceType,
                                                            didImageSelect: didImageSelect,
                                                            parentViewController: viewController)
        imagePickerCoordinator.start()
    }
    
}
