//
//  AccountViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
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
    private let authorizator: LoginableProtocol
    private let context: SingInPublisherContextProtocol
    
    private var cancellables: [AnyCancellable]
    
    // MARK: - Init
    
    init(router: AccountNavigationProtocol, authorizator: LoginableProtocol, context: SingInPublisherContextProtocol) {
        self.router = router
        self.authorizator = authorizator
        self.context = context
        
        self.cancellables = []
        
        bindContext()
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        context.userSingInPublisher.sink { [weak self] (user) in
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
        let rightBarButtons = authorizator.isUserLogin ? [logoutBarButton] : [singInBarButton]
        return NavigationItemDrivableModel(title: "Hello, Anonimus".localize,
                                           leftBarButtonDrivableModels: [],
                                           rightBarButtonDrivableModels: rightBarButtons)
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: .white,
                                   prefersLargeTitles: true)
    }
    
}

// MARK: - AccountOutputProtocol

extension AccountViewModel: AccountOutputProtocol {
    
}
