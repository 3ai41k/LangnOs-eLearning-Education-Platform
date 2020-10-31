//
//  MessageTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MessageTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: MessageCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        label.text = viewModel?.message
    }

}
