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
    private let dataProvider: FirebaseDatabaseCreatingProtocol
    private let userSession: SessionLifecycleProtocol
    
    private var user: User1
    
    // MARK: - Init
    
    init(router: SingUpCoordinatorProtocol,
         dataProvider: FirebaseDatabaseCreatingProtocol,
         userSession: SessionLifecycleProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        
        self.user = .empty
    }
    
    // MARK: - Actions
    
    @objc
    private func didPasswordEnter(_ password: String) {
        user.password = password
    }
    
    @objc
    private func didEmailEnter(_ email: String) {
        user.email = email
    }
    
    @objc
    private func didNameEnter(_ name: String) {
        user.name = name
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
        let request = UserCreateRequest(user: user)
        dataProvider.create(request: request, onSuccess: {
            self.userSession.starSession(with: self.user)
            self.router.close()
        }) { (error) in
            self.router.showError(error)
        }
    }
    
}
