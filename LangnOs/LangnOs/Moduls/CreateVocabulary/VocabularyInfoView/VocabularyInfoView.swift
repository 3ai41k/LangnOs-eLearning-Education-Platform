//
//  VocabularyInfoView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyInfoView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var nameInputView: InputView! {
        didSet {
            nameInputView.textDidEnter = {
                self.nameHandler?($0)
            }
        }
    }
    @IBOutlet private weak var selectCategoryButton: UIButton!
    
    // MARK: - Public methods
    
    var nameHandler: ((String) -> Void)?
    var selectCategoryHandler: ((UIView) -> Void)?
    var isPrivateOnHandler: ((Bool) -> Void)?
    
    var selectButtonTitle: String? {
        didSet {
            selectCategoryButton.setTitle(selectButtonTitle, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didSelectCategoryTouch(_ sender: UIButton) {
        selectCategoryHandler?(sender)
    }
    
    @IBAction
    private func didPrivateOn(_ sender: UISwitch) {
        isPrivateOnHandler?(sender.isOn)
    }
    
}
