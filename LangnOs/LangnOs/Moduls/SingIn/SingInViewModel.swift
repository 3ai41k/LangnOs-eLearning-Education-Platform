//
//  SingInViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol SingInInputProtocol {
    var inputViewModels: [DrivableModelProtocol] { get }
}

protocol SingInOutputProtocol {
    func nextAction()
    func singUpAction()
}

final class SingInViewModel {
    
    // MARK: - Private properties
    
    private let router: SingInCoordinatorProtocol
    private let authorizator: RegistratableProtocol
    private let context: SingUpPublisherContextProtocol
    
    private var cancellables: [AnyCancellable]
    
    private var email: String
    private var password: String
    
    // MARK: - Init
    
    init(router: SingInCoordinatorProtocol,
         authorizator: RegistratableProtocol,
         context: SingUpPublisherContextProtocol) {
        self.router = router
        self.authorizator = authorizator
        self.context = context
        
        self.cancellables = []
        
        self.email = ""
        self.password = ""
        
        bindContext()
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        context.singUpPublisher.sink { [weak self] in
            self?.router.close()
        }.store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc
    private func didEmailEnter(_ email: String) {
        self.email = email
    }
    
    @objc
    private func didPasswordEnter(_ password: String) {
        self.password = password
    }
    
}

// MARK: - SingInInputProtocol

extension SingInViewModel: SingInInputProtocol {
    
    var inputViewModels: [DrivableModelProtocol] {
        [
            InputViewDrivableModel(text: "Password:".localize,
                                   placeholder: "Enter".localize,
                                   textDidEnter: didPasswordEnter),
            InputViewDrivableModel(text: "Email:".localize,
                                   placeholder: "Enter".localize,
                                   textDidEnter: didEmailEnter)
        ]
    }
    
}

// MARK: - SingInOutputProtocol

extension SingInViewModel: SingInOutputProtocol {
    
    func singUpAction() {
        router.navigateToSingUp()
    }
    
    func nextAction() {
        guard !email.isEmpty, !password.isEmpty else {
            self.router.showAlert(title: "Attention!", message: "One of the fields in empty", actions: [
                OkAlertAction(handler: {})
            ])
            return
        }
        authorizator.singInWith(email: email, password: password) { (error) in
            if let error = error {
                // TO DO: errror handling
                print(error.localizedDescription)
            }
        }
    }
    
}
