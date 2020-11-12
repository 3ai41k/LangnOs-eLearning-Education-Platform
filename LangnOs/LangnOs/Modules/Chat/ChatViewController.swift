//
//  ChatViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class ChatViewController: BindibleViewController<ChatViewModel> {
    
    // MARK: - IBOutlets
    // MARK: - Public properties
    // MARK: - Private properties
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Init
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
    }
    
    override func setupUI() {
        
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
}

