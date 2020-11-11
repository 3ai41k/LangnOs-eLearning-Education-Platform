//
//  SingInCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol SingInNavigationProtocol {
    func navigateToSingUp()
}

typealias SingInCoordinatorProtocol =
    SingInNavigationProtocol &
    AlertPresentableProtocol &
    ActivityPresentableProtocol &
    CoordinatorClosableProtocol

final class SingInCoordinator: Coordinator, SingInCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = FirebaseDatabase.shared
        let userSession = UserSession.shared
        let validator = Validator()
        let singInViewModel = SingInViewModel(router: self,
                                              dataProvider: dataProvider,
                                              userSession: userSession,
                                              validator: validator)
        
        let singInViewController = SingInViewController()
        singInViewController.viewModel = singInViewModel
        
        viewController = singInViewController
        parentViewController?.present(singInViewController, animated: true, completion: nil)
    }
    
    // MARK: - SingInNavigationProtocol
    
    func navigateToSingUp() {
        let singUpCoordinator = SingUpCoordinator(parentViewController: viewController)
        singUpCoordinator.start()
    }
    
}
