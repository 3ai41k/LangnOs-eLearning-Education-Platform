//
//  FilterTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class FilterTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {

    // MARK: - IBOutlets
    // MARK: - Public properties
    
    var viewModel: FilterTableViewCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        accessoryType = selected ? .checkmark : .none
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func bindViewModel() {
        textLabel?.text = viewModel?.title
        imageView?.image = viewModel?.image
    }
    
    // MARK: - Actions
    
}
