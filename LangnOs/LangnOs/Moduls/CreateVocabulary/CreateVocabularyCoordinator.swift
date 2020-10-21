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
    
    private let user: User
    private let didVocabularyCreateHandler: (Vocabulary) -> Void
    
    // MARK: - Init
    
    init(user: User,
         didVocabularyCreateHandler: @escaping (Vocabulary) -> Void,
         parentViewController: UIViewController?) {
        self.user = user
        self.didVocabularyCreateHandler = didVocabularyCreateHandler
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let dataFacade = DataFacade()
        let createVocabularyViewModel = CreateVocabularyViewModel(router: self,
                                                                  user: user,
                                                                  dataFacade: dataFacade)
        let createVocabularyCellFactory = CreateVocabularyCellFactory()
        let createVocabularyViewController = CreateVocabularyViewController()
        createVocabularyViewController.tableViewCellFactory = createVocabularyCellFactory
        createVocabularyViewController.viewModel = createVocabularyViewModel
        
        let navigationController = UINavigationController(rootViewController: createVocabularyViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController = navigationController
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
