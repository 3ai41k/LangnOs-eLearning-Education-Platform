//
//  Coordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

class Coordinator {
    
    // MARK: - Protected(Internal) properties
    
    internal weak var parentViewController: UIViewController?
    internal var viewController: UIViewController?
    
    // MARK: - Init
    
    init(parentViewController: UIViewController?) {
        self.parentViewController = parentViewController
    }
    
    // MARK: - Protected(Internal) methods
    
    internal func start() {
        assertionFailure("start() method isn't implemented")
    }
    
}
