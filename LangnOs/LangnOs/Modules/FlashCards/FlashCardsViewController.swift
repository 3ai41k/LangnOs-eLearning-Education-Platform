//
//  FlashCardsViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

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
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.title.sink(receiveValue: { [weak self] (title) in
                self?.title = title
            })
        ]
    }
    
    override func setupUI() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didDoneButtonTouch))
        let moreButton = UIBarButtonItem(image: SFSymbols.more(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didMoreButtonTouch))
        
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = moreButton
    }
    
    // MARK: - Actions
    
    @objc
    private func didDoneButtonTouch() {
        viewModel?.closeAction()
    }
    
    @objc
    private func didMoreButtonTouch() {
        viewModel?.settingsAction()
    }
    
}
