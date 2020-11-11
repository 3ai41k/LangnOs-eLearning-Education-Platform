//
//  PresentationViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class PresentationViewController: BindibleViewController<PresentationViewModelInputProtocol & PresentationViewModelOutputProtocol> {

    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didStartTouched(_ sender: Any) {
        viewModel?.startAction()
    }
    
}
