//
//  AccountViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class AccountViewController: BindibleViewController<AccountViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.actionSubject.send(.downloadUserImage)
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            
        ]
    }

}
