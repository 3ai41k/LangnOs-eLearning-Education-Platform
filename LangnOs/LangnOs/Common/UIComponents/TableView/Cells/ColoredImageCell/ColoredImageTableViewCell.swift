//
//  ColoredImageTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ColoredImageTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var coloredView: UIView! {
        didSet {
            coloredView.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet private weak var coloredImageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ColoredImageCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        accessoryType = viewModel?.accessoryType ?? .none
        label.text = viewModel?.text
        coloredImageView.image = viewModel?.image
        coloredView.backgroundColor = viewModel?.color
    }
    
}
