//
//  VocabularySettingsCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

typealias VocabularySettingsCoordinatorProtocol =
    CoordinatorClosableProtocol &
    AlertPresentableProtocol

final class VocabularySettingsCoordinator: Coordinator, VocabularySettingsCoordinatorProtocol  {
    
    // MARK: - Private properties
    
    private let interactor: Interactor
    private let transition: BottomCardTransition
    private let actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>
    
    // MARK: - Init
    
    init(actionSubject: PassthroughSubject<VocabularySettingsRowAction, Never>, parentViewController: UIViewController?) {
        self.interactor = Interactor()
        self.transition = BottomCardTransition()
        self.transition.interactor = interactor
        self.actionSubject = actionSubject
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewModel = VocabularySettingsViewModel(router: self, actionSubject: actionSubject)
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

extension VocabularySettingsCoordinator {
    
    enum Constants {
        static let contentSize = CGSize(width: .zero, height: 400.0)
    }
    
}


