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
    var header: String { get }
    var description: String { get }
    var inputDrivingModels: [DrivableModelProtocol] { get }
    var buttonsDrivingModels: [DrivableModelProtocol] { get }
}

protocol SingInOutputProtocol {
    func nextAction()
}

final class SingInViewModel {
    
    // MARK: - Private properties
    
    private let router: SingInCoordinatorProtocol
    private let authorizator: RegistratableProtocol
    private let context: SingInContextProtocol & SingUpPublisherContextProtocol
    
    private var cancellables: [AnyCancellable]
    
    private var email: String
    private var password: String
    
    // MARK: - Init
    
    init(router: SingInCoordinatorProtocol,
         authorizator: RegistratableProtocol,
         context: SingInContextProtocol & SingUpPublisherContextProtocol) {
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
        context.backToAuthorizePublisher.sink { [weak self] _ in
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
    
    @objc
    private func didSingup() {
        router.navigateToSingUp()
    }
    
    private func singUpAction() {
        router.navigateToSingUp()
    }
    
}

// MARK: - SingInInputProtocol

extension SingInViewModel: SingInInputProtocol {
    
    var header: String {
        "Welocme Back!".localize
    }
    
    var description: String {
        "Sing in".localize
    }
    
    var inputDrivingModels: [DrivableModelProtocol] {
        [
            InputViewDrivableModel(text: nil,
                                   textFieldDrivableModel: TextFieldDrivableModel(placeholder: "Password".localize, returnKey: .done, contentType: .password),
                                   textDidEnter: didPasswordEnter),
            InputViewDrivableModel(text: nil,
                                   textFieldDrivableModel: TextFieldDrivableModel(placeholder: "Email".localize, contentType: .emailAddress),
                                   textDidEnter: didEmailEnter)
        ]
    }
    
    var buttonsDrivingModels: [DrivableModelProtocol] {
        [
            ButtonDrivableModel(title: "Sing up".localize,
                                titleColor: .black,
                                target: self,
                                selector: #selector(didSingup))
        ]
    }
    
}

// MARK: - SingInOutputProtocol

extension SingInViewModel: SingInOutputProtocol {
    
    func nextAction() {
        guard !email.isEmpty, !password.isEmpty else {
            self.router.showAlert(title: "Attention!", message: "One of the fields in empty", actions: [
                OkAlertAction(handler: {})
            ])
            return
        }
        authorizator.singInWith(email: email, password: password) { (result) in
            switch result {
            case .success(let user):
                self.context.userDidSingIn(user)
                self.router.close()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
