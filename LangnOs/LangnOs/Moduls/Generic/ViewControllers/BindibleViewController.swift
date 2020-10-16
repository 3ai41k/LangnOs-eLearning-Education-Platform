//
//  BindibleViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

//protocol BindibleViewModel {
//    var updateUI: (() -> Void)? { get set }
//}
//
//extension BindibleViewModel {
//    var updateUI: (() -> Void)? { nil }
//}

class BindibleViewController<ViewModel>: UIViewController {
    
    // MARK: - Public properties
    
    var viewModel: ViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
        configurateComponents()
    }
    
    // MARK: - Protected(internal) methods
    
    internal func bindViewModel() {
//        viewModel?.updateUI = { [weak self] in
//            self?.setupUI()
//        }
    }
    
    internal func setupUI() { }
    
    internal func configurateComponents() { }
    
}
