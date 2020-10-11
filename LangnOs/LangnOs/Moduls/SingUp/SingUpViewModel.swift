//
//  SingUpViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class SingUpViewModel {
    
    // MARK: - Private properties
    
    private let router: SingUpCoordinatorProtocol
    private let authorizator: RegistratableProtocol
    private let context: SingUpContextProtocol
    
    private var name: String
    private var email: String
    private var password: String
    
    // MARK: - Init
    
    init(router: SingUpCoordinatorProtocol,
         authorizator: RegistratableProtocol,
         context: SingUpContextProtocol) {
        self.router = router
        self.authorizator = authorizator
        self.context = context
        
        self.name = ""
        self.email = ""
        self.password = ""
    }
    
    // MARK: - Actions
    
    @objc
    private func didPasswordEnter(_ password: String) {
        self.password = password
    }
    
    @objc
    private func didEmailEnter(_ email: String) {
        self.email = email
    }
    
    @objc
    private func didNameEnter(_ name: String) {
        self.name = name
    }
    
}

// MARK: - SingInInputProtocol

extension SingUpViewModel: SingInInputProtocol {
    
    var header: String {
        "Create Account".localize
    }
    
    var description: String {
        "Sing up".localize
    }
    
    var inputDrivingModels: [DrivableModelProtocol] {
        [
            InputViewDrivableModel(text: nil,
                                   textFieldDrivableModel: TextFieldDrivableModel(placeholder: "Password".localize, returnKey: .done, contentType: .password),
                                   textDidEnter: didPasswordEnter),
            InputViewDrivableModel(text: nil,
                                   textFieldDrivableModel: TextFieldDrivableModel(placeholder: "Email".localize, contentType: .emailAddress),
                                   textDidEnter: didEmailEnter),
            InputViewDrivableModel(text: nil,
                                   textFieldDrivableModel: TextFieldDrivableModel(placeholder: "Name".localize),
                                   textDidEnter: didNameEnter)
            
        ]
    }
    
    var buttonsDrivingModels: [DrivableModelProtocol] {
        []
    }
    
}

// MARK: - SingInOutputProtocol

extension SingUpViewModel: SingInOutputProtocol {
    
    func nextAction() {
        guard !email.isEmpty, !password.isEmpty else {
            self.router.showAlert(title: "Attention!", message: "One of the fields in empty", actions: [
                OkAlertAction(handler: {})
            ])
            return
        }
        authorizator.singUpWith(name: name, email: email, password: password) { (result) in
            switch result {
            case .success(let user):
                self.router.close {
                    self.context.userDidCreate(user)
                }
            case .failure(let error):
                // TO DO: errror handling
                print(error.localizedDescription)
            }
        }
    }
    
}
