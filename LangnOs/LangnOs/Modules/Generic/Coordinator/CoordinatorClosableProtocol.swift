//
//  CoordinatorClosableProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

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
