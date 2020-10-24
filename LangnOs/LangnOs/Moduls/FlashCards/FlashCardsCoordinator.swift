//
//  FlashCardsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol FlashCardsNavigationProtocol {
    func navigateToSettings()
}

typealias FlashCardsCoordinatorProtocol =
    FlashCardsNavigationProtocol &
    AlertPresentableProtocol &
    CoordinatorClosableProtocol

final class FlashCardsCoordinator: Coordinator, FlashCardsCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let words: [Word]
    
    // MARK: - Init
    
    init(words: [Word], parentViewController: UIViewController?) {
        self.words = words
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let speechSynthesizer = SpeechSynthesizer()
        let viewModel = FlashCardsViewModel(router: self,
                                            words: words,
                                            speechSynthesizer: speechSynthesizer)
        
        let cellFactory = FlashCardsCellFactory()
        let viewController = FlashCardsViewController()
        viewController.viewModel = viewModel
        viewController.tableViewCellFactory = cellFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.viewController = navigationController
        parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - FlashCardsNavigationProtocol
    
    func navigateToSettings() {
        let flashCardsSettingsCoordinator = FlashCardsSettingsCoordinator(parentViewController: viewController)
        flashCardsSettingsCoordinator.start()
    }
    
}
