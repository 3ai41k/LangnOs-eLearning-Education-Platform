//
//  VocabularySettingsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class VocabularySettingsViewController: BindibleViewController<VocabularySettingsViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            
            tableView.start()
        }
    }
    
    
    // MARK: - Public properties
    
    var interactor: Interactor?
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Lifecycle
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.title.sink(receiveValue: { [weak self] (title) in
                self?.title = title
            })
        ]
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

