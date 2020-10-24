//
//  VocabularySettingsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularySettingsViewController: BindibleViewController<VocabularySettingsViewModelProtocol> {
    
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
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didCloseButtonTouch))
        navigationItem.rightBarButtonItem = closeButton
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    
    var interactor: Interactor?
    
    
    // MARK: - Private methods
    
    
    
    // MARK: - Actions
    
    @objc
    private func didCloseButtonTouch() {
        viewModel?.closeAction()
    }
    
    @IBAction
    private func handleGesture(_ sender: UIPanGestureRecognizer) {
        
    }
    
}

