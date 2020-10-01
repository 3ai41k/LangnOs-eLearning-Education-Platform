//
//  BindibleViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

class BindibleViewController<ViewModel>: UIViewController {
    
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    internal func bindViewModel() {
        
    }
    
}
