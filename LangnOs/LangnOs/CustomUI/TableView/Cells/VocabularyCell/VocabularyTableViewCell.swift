//
//  CreateWordTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class VocabularyTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable, CellResizableProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
            containerView.setShadow(color: .black, opacity: 0.25)
        }
    }
    @IBOutlet private weak var wordImageView: UIImageView!
    @IBOutlet private weak var headerInputView: InputView! {
        didSet {
            headerInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setHeaderValue(text)
            }
        }
    }
    @IBOutlet private weak var footerInputView: InputView! {
        didSet {
            footerInputView.textDidEnter = { [weak self] (text) in
                self?.viewModel?.setFooterValue(text)
            }
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: VocabularyCellViewModelProtocol? {
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
        headerInputView.value = viewModel?.headerValue
        footerInputView.value = viewModel?.footerValue
        cancellables = [
            viewModel?.toolbarDrivableModel.sink(receiveValue: { [weak self] (drivableModel) in
                [self?.headerInputView, self?.footerInputView].forEach({
                    let sreenWidth = UIScreen.main.bounds.width
                    let rect = CGRect(x: .zero, y: .zero, width: sreenWidth, height: 44.0)
                    let toolbar = UIToolbar(frame: rect)
                    toolbar.drive(model: drivableModel)
                    $0?.textFieldInputAccessoryView = toolbar
                })
            }),
            viewModel?.headerTitle.assign(to: \.title, on: headerInputView),
            viewModel?.footerTitle.assign(to: \.title, on: footerInputView),
            viewModel?.image.sink(receiveValue: { [weak self] image in
                self?.beginUpdate?()
                self?.wordImageView.image = image
                self?.wordImageView.isHidden = image == nil
                self?.endUpdate?()
            })
        ]
    }
    
}
