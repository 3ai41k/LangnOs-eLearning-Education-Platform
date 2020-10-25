//
//  BindibleViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

class BindibleViewController<ViewModel>: UIViewController {
    
    // MARK: - Public properties
    
    var viewModel: ViewModel?
    var cancellables: [AnyCancellable?] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
        configurateComponents()
    }
    
    // MARK: - Protected(internal) methods
    
    internal func bindViewModel() { }
    
    internal func setupUI() { }
    
    internal func configurateComponents() { }
    
}
