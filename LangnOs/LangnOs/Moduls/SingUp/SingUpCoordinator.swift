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
    
    // MARK: - Private properties
    
    private let context: SingUpContextProtocol
    
    // MARK: - Init
    
    init(context: SingUpContextProtocol, parentViewController: UIViewController?) {
        self.context = context
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let authorizator = Authorizator()
        let singUpViewModel = SingUpViewModel(router: self, authorizator: authorizator, context: context)
        let singInViewController = SingInViewController()
        singInViewController.viewModel = singUpViewModel
        
        viewController = singInViewController
        parentViewController?.present(singInViewController, animated: true, completion: nil)
    }
    
}