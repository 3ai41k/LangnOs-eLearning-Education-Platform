//
//  SeachVocabularyTableViewCell.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 10.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class SearchVocabularyTableViewCell: UITableViewCell, UniversalTableViewCellRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var termsLabel: UILabel!
    @IBOutlet private weak var userImageContainerView: UIView! {
        didSet {
            userImageContainerView.layer.cornerRadius = userImageContainerView.bounds.height / 2.0
        }
    }
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: SearchVocabularyCellProtocol? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        nameLabel.text = viewModel?.name
        termsLabel.text = viewModel?.terms
        viewModel?.image.compactMap({ $0 }).sink(receiveValue: { [weak self] (image) in
            self?.userImageView.image = image
            self?.activityIndicator.stopAnimating()
        }).store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didSaveTouch(_ sender: Any) {
        viewModel?.save()
    }
    
}
