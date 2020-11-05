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
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Public properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension VocabularyCategoryViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
}

