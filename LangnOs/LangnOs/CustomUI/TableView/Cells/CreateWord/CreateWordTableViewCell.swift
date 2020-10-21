//
//  CreateWordTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class CreateWordTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable, CellResizableProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
            containerView.setShadow(color: .black, opacity: 0.25)
        }
    }
    @IBOutlet private weak var termImageView: UIImageView!
    @IBOutlet private weak var termInputView: InputView! {
        didSet {
            termInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setTerm(text)
            }
        }
    }
    @IBOutlet private weak var definitionInputView: InputView! {
        didSet {
            definitionInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setDefinition(text)
            }
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: (CreateWordTableViewCellInputProtocol & CreateWordTableViewCellOutputProtocol)? {
        didSet {
            bindViewModel()
        }
    }
    
    var beginUpdate: (() -> Void)?
    var endUpdate: (() -> Void)?
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        termInputView.value = viewModel?.term
        definitionInputView.value = viewModel?.definition
        [termInputView, definitionInputView].forEach({
            let sreenWidth = UIScreen.main.bounds.width
            let rect = CGRect(x: .zero, y: .zero, width: sreenWidth, height: 44.0)
            let toolbar = UIToolbar(frame: rect)
            toolbar.drive(model: viewModel?.toolbarDrivableModel)
            $0?.textFieldInputAccessoryView = toolbar
        })
        cancellables = [
            viewModel?.image.sink(receiveValue: { [weak self] image in
                self?.beginUpdate?()
                self?.termImageView.image = image
                self?.termImageView.isHidden = image == nil
                self?.endUpdate?()
            })
        ]
    }
    
}
