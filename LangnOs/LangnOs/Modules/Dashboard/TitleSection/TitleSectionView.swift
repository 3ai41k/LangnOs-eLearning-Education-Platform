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
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Public properties
    
    var viewModel: TitleSectionViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        label.text = viewModel?.text
        label.font = viewModel?.font
        
        if let buttonText = viewModel?.buttonText {
            button.setTitle(buttonText, for: .normal)
        } else {
            button.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didButtonTouch(_ sender: Any) {
        viewModel?.selectAction()
    }
    
}
