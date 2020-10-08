//
//  SingInViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class SingInViewController: BindibleViewController<SingInInputProtocol & SingInOutputProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            setupInputViews()
        }
    }
    
    // MARK: - Public properties
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func setupInputViews() {
        viewModel?.inputViewModels.forEach({
            let inputView = InputView()
            inputView.drive(model: $0)
            self.stackView.insertArrangedSubview(inputView, at: 0)
        })
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didSingupTouched(_ sender: Any) {
        viewModel?.singUpAction()
    }
    
    @IBAction
    private func didNextTouched(_ sender: Any) {
        viewModel?.nextAction()
    }
    
}
