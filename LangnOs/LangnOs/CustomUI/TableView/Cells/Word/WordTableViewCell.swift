//
//  WordTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class WordTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var termLabel: UILabel!
    @IBOutlet private weak var definitionLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: WordTableViewCellInputProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        termLabel.text = viewModel?.term
        definitionLabel.text = viewModel?.definition
    }
    
}
