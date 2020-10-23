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
    func vocabularyDidCreate(_ vocabulary: Vocabulary)
    func navigateToImagePicker(sourceType: UIImagePickerController.SourceType, didImageSelect: @escaping (UIImage) -> Void)
}

typealias CreateVocabularyCoordinatorProtocol =
    CreateVocabularyNavigationProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol

final class CreateVocabularyCoordinator: Coordinator, CreateVocabularyCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let didVocabularyCreateHandler: (Vocabulary) -> Void
    
    // MARK: - Init
    
    init(didVocabularyCreateHandler: @escaping (Vocabulary) -> Void,
         parentViewController: UIViewController?) {
        self.didVocabularyCreateHandler = didVocabularyCreateHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = CreateVocabularyViewModel(router: self)
        let cellFactory = CreateVocabularyCellFactory()
        let viewController = CreateVocabularyViewController()
        viewController.tableViewCellFactory = cellFactory
        viewController.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.viewController = navigationController
        parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - CreateVocabularyNavigationProtocol
    
    func vocabularyDidCreate(_ vocabulary: Vocabulary) {
        close {
            self.didVocabularyCreateHandler(vocabulary)
        }
    }
    
    func navigateToImagePicker(sourceType: UIImagePickerController.SourceType, didImageSelect: @escaping (UIImage) -> Void) {
        let imagePickerCoordinator = ImagePickerCoordinator(sourceType: sourceType,
                                                            didImageSelect: didImageSelect,
                                                            parentViewController: viewController)
        imagePickerCoordinator.start()
    }
    
}
