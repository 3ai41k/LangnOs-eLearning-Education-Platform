//
//  MessageInputView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 13.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class MessageInputView: XibView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var messageTextField: UITextField! {
        didSet {
            messageTextField.delegate = self
        }
    }
    
    // MARK: - Public properties
    
    var returnHandler: ((String) -> Void)?
    var paperclipHandler: (() -> Void)?
    
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    
    @IBAction
    private func didPaperclipTouch(_ sender: Any) {
        paperclipHandler?()
    }
    
    @IBAction
    private func didPaperplaneTouch(_ sender: Any) {
        guard let text = messageTextField.text else { return }
        returnHandler?(text)
        messageTextField.text = nil
    }

}

// MARK: - UITextFieldDelegate

extension MessageInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false}
        returnHandler?(text)
        textField.text = nil
        return true
    }
    
}
