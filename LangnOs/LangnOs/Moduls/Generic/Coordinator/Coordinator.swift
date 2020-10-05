//
//  Coordinator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol CoordinatorClosableProtocol {
    func close(completion: (() -> Void)?)
    func close()
}

extension CoordinatorClosableProtocol where Self: Coordinator {
    
    func close(completion: (() -> Void)?) {
        viewController?.dismiss(animated: true, completion: completion)
    }
    
    func close() {
        close(completion: nil)
    }
    
}

protocol ActivityPresentableProtocol {
    func showActivity()
    func closeActivity()
}

extension ActivityPresentableProtocol where Self: Coordinator {
    
    func showActivity() {
        let activityViewController = ActivityViewController()
        viewController?.present(activityViewController, animated: false, completion: nil)
    }
    
    func closeActivity() {
        viewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
}

class Coordinator {
    
    // MARK: - Protected(Internal) properties
    
    internal weak var parentViewController: UIViewController?
    internal weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(parentViewController: UIViewController?) {
        self.parentViewController = parentViewController
    }
    
    // MARK: - Protected(Internal) methods
    
    internal func start() {
        assertionFailure("start() method isn't implemented")
    }
    
}
