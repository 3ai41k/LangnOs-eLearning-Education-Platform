//
//  SceneDelegate.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Private properties
    
    private var rootCoordinator: Coordinator?
    private var dataSynchronizer: CloudSynchronizeProtocol = DataSynchronizer.shared
    
    private let coreDataStack = CoreDataStack.shared
    
    // MARK: - Public methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = windowScene.windows.first
        
        setupRootCoordinator()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print(#function)
        
        dataSynchronizer.cancelAllOperations()
        coreDataStack.save()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
        
        coreDataStack.save()
    }
    
    // MARK: - Private methods
    
    private func setupRootCoordinator() {
        rootCoordinator = RootCoordinator(window: window!)
        rootCoordinator?.start()
    }
    
}

