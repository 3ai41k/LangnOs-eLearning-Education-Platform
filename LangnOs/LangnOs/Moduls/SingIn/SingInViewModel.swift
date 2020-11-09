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
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    private let userSession: SessionLifecycleProtocol
    private var user: User1
    
    // MARK: - Init
    
    init(router: SingInCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol,
         userSession: SessionLifecycleProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        self.userSession = userSession
        self.user = .empty
    }
    
    // MARK: - Actions
    
    @objc
    private func didEmailEnter(_ email: String) {
        user.email = email
    }
    
    @objc
    private func didPasswordEnter(_ password: String) {
        user.password = password
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
                                titleColor: .label,
                                target: self,
                                selector: #selector(didSingup))
        ]
    }
    
}

// MARK: - SingInOutputProtocol

extension SingInViewModel: SingInOutputProtocol {
    
    func nextAction() {
        let request = UserFetchRequest(email: user.email, password: user.password)
        dataProvider.fetch(request: request, onSuccess: { (users: [User1]) in
            guard let user = users.first else { return }
            self.userSession.starSession(with: user)
            self.router.close()
        }) { (error) in
            self.router.showError(error)
        }
    }
    
}
