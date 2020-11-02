//
//  VocabularyCategoryViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class VocabularyCategoryViewController: BindibleViewController<VocabularyCategoryViewModel> {
    
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
        
    }
    
    override func setupUI() {
        
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension VocabularyCategoryViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
}

