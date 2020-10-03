//
//  SingInCoordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class SingInCoordinator: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let singInViewController = SingInViewController()
        
        viewController = singInViewController
        parentViewController?.present(singInViewController, animated: true, completion: nil)
    }
    
}
