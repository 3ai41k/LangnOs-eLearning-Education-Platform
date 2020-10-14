//
//  ActivityPresentableProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol ActivityPresentableProtocol {
    func showActivity()
    func closeActivity()
}

extension ActivityPresentableProtocol where Self: Coordinator {
    
    func showActivity() {
        let activityViewController = ActivityViewController()
        activityViewController.modalPresentationStyle = .overCurrentContext
        viewController?.present(activityViewController, animated: false, completion: nil)
    }
    
    func closeActivity() {
        viewController?.presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
}
