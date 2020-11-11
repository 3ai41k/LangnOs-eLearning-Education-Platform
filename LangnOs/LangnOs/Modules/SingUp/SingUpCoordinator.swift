//
//  SingUpCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

typealias SingUpCoordinatorProtocol = AlertPresentableProtocol & CoordinatorClosableProtocol

final class SingUpCoordinator: Coordinator, SingUpCoordinatorProtocol {
    
    // MARK: - Override
    
    override func start() {
        let dataProvider = FirebaseDatabase.shared
        let userSession = UserSession.shared
        let singUpViewModel = SingUpViewModel(router: self,
                                              dataProvider: dataProvider,
                                              userSession: userSession)
        
        let singInViewController = SingInViewController()
        singInViewController.viewModel = singUpViewModel
        
        viewController = singInViewController
        parentViewController?.present(singInViewController, animated: true, completion: nil)
    }
    
}
