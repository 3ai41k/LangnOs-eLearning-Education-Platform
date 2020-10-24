//
//  ButtonTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ButtonTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Public properties
    
    var viewModel: ButtonCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        button.setTitle(viewModel?.title, for: .normal)
        button.setTitleColor(viewModel?.titleColor, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didButtonTouch(_ sender: Any) {
        viewModel?.buttonAction()
    }
    
}
