//
//  TextTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class TextTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - Public properties
    
    var viewModel: TextCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    // MARK: - Private methods
    
    private func bindViewModel() {
        textLabel?.text = viewModel?.text
    }
    
}
