//
//  FlashCardTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class FlashCardTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var flipContainerView: UIView! {
        didSet {
            flipContainerView.layer.cornerRadius = 20.0
            flipContainerView.setShadow(color: .black, opacity: 0.25)
        }
    }
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var termDefinitionLabel: UILabel!
    @IBOutlet private weak var pronounceButton: UIButton! {
        didSet {
            pronounceButton.layer.cornerRadius = 5.0
            pronounceButton.layer.borderColor = UIColor.systemGray2.cgColor
            pronounceButton.layer.borderWidth = 0.25
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: FlashCardCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable?] = []
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTapGesture()
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        cancellables = [
            viewModel?.header.assign(to: \.text, on: headerLabel),
            viewModel?.term.assign(to: \.text, on: termDefinitionLabel),
            viewModel?.isPronounceButtonEnabled.assign(to: \.isEnabled, on: pronounceButton),
            viewModel?.flipPublisher.sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                UIView.transition(with: self.flipContainerView, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
            })
        ]
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didFlipCard))
        flipContainerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func didFlipCard() {
        viewModel?.flip()
    }
    
    @IBAction
    private func didPronounceTouch(_ sender: Any) {
        viewModel?.pronaunce()
    }
    
}
