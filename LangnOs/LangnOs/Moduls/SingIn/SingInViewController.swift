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
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var textFieldStackView: UIStackView! {
        didSet {
            setupInputViews()
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var bottomStackView: UIStackView! {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        headerLabel.text = viewModel?.header
        descriptionLabel.text = viewModel?.description
    }
    
    // MARK: - Private methods
    
    private func setupInputViews() {
        viewModel?.inputDrivingModels.forEach({
            let inputView = InputView()
            inputView.drive(model: $0)
            self.textFieldStackView.insertArrangedSubview(inputView, at: 0)
        })
    }
    
    private func setupButtons() {
        viewModel?.buttonsDrivingModels.forEach({
            let button = UIButton()
            button.drive(model: $0)
            self.bottomStackView.addArrangedSubview(button)
        })
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didNextTouch(_ sender: Any) {
        viewModel?.done()
    }
    
    @IBAction
    private func didEndEditingTouch(_ sender: Any) {
        view.endEditing(true)
    }
    
}
