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
    
    @IBOutlet private weak var flipContainerView: UIView!
    
    // MARK: - Public properties
    
    var viewModel: FlashCardTableViewCellInputProtocol? {
        didSet {
            
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTapGesture()
    }
    
    // MARK: - Private methods
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didFlipCard))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func didFlipCard() {
        UIView.transition(with: flipContainerView, duration: 1, options: .transitionFlipFromRight, animations: {

        }) { (success) in

        }
    }
    
}
