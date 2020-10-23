//
//  FlashCardsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class FlashCardsViewController: BindibleViewController<FlashCardsViewModelProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = tableViewCellFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var tableViewCellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    
    override func setupUI() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didDoneButtonTouch))
        
        navigationItem.leftBarButtonItem = doneButton
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
    @objc
    private func didDoneButtonTouch() {
        viewModel?.closeAction()
    }
    
}
