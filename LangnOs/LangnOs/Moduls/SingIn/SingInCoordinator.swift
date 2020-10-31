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

typealias SingInCoordinatorProtocol = SingInNavigationProtocol & AlertPresentableProtocol & CoordinatorClosableProtocol

final class SingInCoordinator: Coordinator, SingInCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let authorizator = Authorizator()
        let singInViewModel = SingInViewModel(router: self,
                                              authorizator: authorizator)
        
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
