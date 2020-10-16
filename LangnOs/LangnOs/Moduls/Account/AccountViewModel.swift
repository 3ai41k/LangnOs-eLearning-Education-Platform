//
//  AccountViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth
import Combine

protocol AccountInputProtocol: NavigatableViewModelProtocol {
    
}

protocol AccountOutputProtocol {
    
}

protocol AccountBindingProtocol {
    var reloadUI: (() -> Void)? { get set }
}

final class AccountViewModel: AccountBindingProtocol {
    
    // MARK: - Public properties
    
    var reloadUI: (() -> Void)?
    
    // MARK: - Private properties
    
    private let router: AccountNavigationProtocol
    private let context: SingInPublisherContextProtocol & UserSessesionContextProtocol
    private let securityManager: SecurityManager
    
    
    private let authorizator: LoginableProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(router: AccountNavigationProtocol,
         context: SingInPublisherContextProtocol & UserSessesionContextProtocol,
         securityManager: SecurityManager,
         authorizator: LoginableProtocol) {
        self.router = router
        self.context = context
        self.securityManager = securityManager
        self.authorizator = authorizator
        
        
        bindContext()
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        context.userSingInPublisher.sink { [weak self] (user) in
            self?.securityManager.setUser(user)
            self?.router.navigateToPresention()
            self?.reloadUI?()
        }.store(in: &cancellables )
    }
    
    // MARK: - Actions
    
    @objc
    private func didSingInTouched() {
        router.navigateToSingIn()
    }
    
    @objc
    private func didLogoutTouched() {
        authorizator.logOut { (error) in
            if let error = error {
                // TO DO: Error handling
                print(error.localizedDescription)
            } else {
                self.securityManager.removeUser()
                self.context.removeUserFromCurrentSession()
                self.reloadUI?()
            }
        }
    }
    
}

// MARK: - AccountInputProtocol

extension AccountViewModel: AccountInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let singInBarButton = BarButtonDrivableModel(title: "Sing In".localize,
                                                     style: .done,
                                                     target: self,
                                                     selector: #selector(didSingInTouched))
        let logoutBarButton = BarButtonDrivableModel(title: "Log out".localize,
                                                     style: .done,
                                                     target: self,
                                                     selector: #selector(didLogoutTouched))
        let title = "Hello, \(securityManager.user?.displayName ?? "Anonimus")"
        let rightBarButtons = securityManager.user != nil ? [logoutBarButton] : [singInBarButton]
        return NavigationItemDrivableModel(title: title,
                                           leftBarButtonDrivableModels: [],
                                           rightBarButtonDrivableModels: rightBarButtons)
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol? {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .white,
                                   prefersLargeTitles: true)
    }
    
}

// MARK: - AccountOutputProtocol

extension AccountViewModel: AccountOutputProtocol {
    
}
