//
//  TitleSectionView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class TitleSectionView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: TitleSectionViewModelInput? {
        didSet {
            bindViewModel()
        }
    }
    // MARK: - Private methods
    
    private func bindViewModel() {
        label.text = viewModel?.text
        label.font = viewModel?.font
    }
    
}
