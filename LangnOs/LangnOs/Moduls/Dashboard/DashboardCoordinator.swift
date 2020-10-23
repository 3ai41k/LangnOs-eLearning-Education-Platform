//
//  MainCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol DashboardNavigationProtocol {
    func navigateToUserProfile()
    func navigateToMaterials()
}

typealias DashboardCoordinatorProtocol = DashboardNavigationProtocol & AlertPresentableProtocol

final class DashboardCoordinator: Coordinator, DashboardCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let context: RootContextProtocol
    
    // MARK: - Init
    
    init(context: RootContextProtocol, parentViewController: UIViewController?) {
        self.context = context
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let securityManager = SecurityManager.shared
        let dataFacade = DataFacade()
        let viewModel = DashboardViewModel(router: self,
                                           contex: context,
                                           securityManager: securityManager,
                                           dataFacade: dataFacade)
        
        let cellFactory = DashboardCellFactory()
        let sectionFactory = DashboardSectionFactory()
        let viewController = DashboardViewController()
        viewController.viewModel = viewModel
        viewController.cellFactory = cellFactory
        viewController.sectionFactory = sectionFactory
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(provider: .dashboard)
        
        self.viewController = navigationController
    }
    
    // MARK: - MainNavigationProtocol
    
    func navigateToUserProfile() {
        let accountCoordinator = AccountCoordinator(context: context, parentViewController: viewController)
        accountCoordinator.start()
    }
    
    func navigateToMaterials() {
        let materialsCoordinator = MaterialsCoordinator(parentViewController: viewController)
        materialsCoordinator.start()
    }
    
}
