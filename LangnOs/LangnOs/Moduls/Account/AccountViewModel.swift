//
//  AccountViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol AccountInputProtocol: NavigatableViewModelProtocol {
    
}

protocol AccountOutputProtocol {
    
}

final class AccountViewModel {
    
    private let router: AccountNavigationProtocol
    private let authorizator: LoginableProtocol
    
    init(router: AccountNavigationProtocol, authorizator: LoginableProtocol) {
        self.router = router
        self.authorizator = authorizator
    }
    
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
                print("Did logout")
            }
        }
    }
    
}

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

extension AccountViewModel: AccountOutputProtocol {
    
}
