//
//  VocabularyTableViewCell.swift
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
        }
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var termImageView: UIImageView! {
        didSet {
            termImageView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var headerInputView: InputView! {
        didSet {
            headerInputView.textDidEnter = { (text) in
                self.viewModel?.setHeaderValue(text)
            }
        }
    }
    @IBOutlet private weak var footerInputView: InputView! {
        didSet {
            footerInputView.textDidEnter = { (text) in
                self.viewModel?.setFooterValue(text)
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
        if let toolbarDrivableModel = viewModel?.toolbarDrivableModel {
            [headerInputView, footerInputView].forEach({
                let sreenWidth = UIScreen.main.bounds.width
                let rect = CGRect(x: .zero, y: .zero, width: sreenWidth, height: 44.0)
                let toolbar = UIToolbar(frame: rect)
                toolbar.drive(model: toolbarDrivableModel)
                $0?.textFieldInputAccessoryView = toolbar
            })
        }
        cancellables = [
            viewModel?.headerTitle.assign(to: \.title, on: headerInputView),
            viewModel?.footerTitle.assign(to: \.title, on: footerInputView),
            viewModel?.showActivity.sink(receiveValue: { [weak self] (showActivity) in
                self?.activityIndicator.isHidden = !showActivity
            }),
            viewModel?.isEditable.assign(to: \.isEditable, on: headerInputView),
            viewModel?.isEditable.assign(to: \.isEditable, on: footerInputView),
            viewModel?.image.sink(receiveValue: { [weak self] image in
                self?.beginUpdate?()
                self?.termImageView.image = image
                self?.termImageView.isHidden = image == nil
                self?.endUpdate?()
            })
        ]
    }
    
}
