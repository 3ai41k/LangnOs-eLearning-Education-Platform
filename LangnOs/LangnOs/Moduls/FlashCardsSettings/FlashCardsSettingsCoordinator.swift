//
//  FlashCardsSettingsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

typealias FlashCardsSettingsCoordinatorProtocol =
    CoordinatorClosableProtocol &
    AlertPresentableProtocol

final class FlashCardsSettingsCoordinator: Coordinator, FlashCardsSettingsCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let interactor: Interactor
    private let transition: BottomCardTransition
    
    // MARK: - Init
    
    override init(parentViewController: UIViewController?) {
        self.interactor = Interactor()
        self.transition = BottomCardTransition()
        self.transition.interactor = interactor
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = FlashCardsSettingsViewModel(router: self)
        let cellFactory = VocabularySettingsCellFactory()
        let viewController = VocabularySettingsViewController()
        viewController.viewModel = viewModel
        viewController.interactor = interactor
        viewController.cellFactory = cellFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = transition
        navigationController.preferredContentSize = Constants.contentSize
        navigationController.modalPresentationStyle = .overCurrentContext
        
        self.viewController = viewController
        self.parentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - Constants

extension FlashCardsSettingsCoordinator {
    
    enum Constants {
        static let contentSize = CGSize(width: .zero, height: 400.0)
    }
    
}
