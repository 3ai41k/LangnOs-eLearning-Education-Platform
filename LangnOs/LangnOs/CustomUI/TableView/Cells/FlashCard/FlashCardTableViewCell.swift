//
//  FlashCardTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class FlashCardTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var flipContainerView: UIView! {
        didSet {
            flipContainerView.layer.cornerRadius = 20.0
            flipContainerView.setShadow(color: .black, opacity: 0.25)
        }
    }
    @IBOutlet private weak var termLabel: UILabel!
    @IBOutlet private weak var pronounceButton: UIButton!
    
    // MARK: - Public properties
    
    var viewModel: (FlashCardTableViewCellInputProtocol & FlashCardTableViewCellOutputProtocol & FlashCardTableViewCellBindingProtocol)? {
        didSet {
            termLabel.text = viewModel?.term
            viewModel?.isPronounceButtonEnabled = { (isEnabled) in
                self.pronounceButton.isEnabled = isEnabled
            }
        }
    }
    
    // MARK: - Private properties
    
    private var isFipped = false
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTapGesture()
    }
    
    // MARK: - Private methods
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didFlipCard))
        flipContainerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func didFlipCard() {
        self.isFipped = isFipped ? false : true
        UIView.transition(with: flipContainerView, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.termLabel.text = self.isFipped ? self.viewModel?.definition : self.viewModel?.term
        })
    }
    
    @IBAction
    private func didPronounceTouch(_ sender: Any) {
        guard let text = termLabel.text else { return }
        viewModel?.speak(text: text)
    }
    
}
