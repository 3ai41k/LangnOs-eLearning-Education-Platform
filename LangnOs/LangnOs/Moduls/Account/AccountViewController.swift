//
//  AccountViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class AccountViewController: BindibleViewController<AccountViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.setСircle()
        }
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.startAnimating()
        }
    }
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var bottomCardView: UIView! {
        didSet {
            bottomCardView.layer.cornerRadius = 20.0
            bottomCardView.setShadow(color: .black, opacity: Constants.shadowOpacity)
            
        }
    }
    @IBOutlet private weak var detailsButton: UIButton! {
        didSet {
            detailsButton.setСircle()
            detailsButton.setShadow(color: .black, opacity: Constants.shadowOpacity)
        }
    }
    
    // MARK: - Private properties
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.dowloadUserImage()
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        viewModel?.userImage.sink(receiveValue: { [weak self] (image) in
            self?.userImageView.image = image
        }).store(in: &cancellables)
        
        viewModel?.reloadUI = { [weak self] in
            self?.setupUI()
        }
    }
    
    override func setupUI() {
        userNameLabel.text = viewModel?.initials
        userEmailLabel.text = viewModel?.email
        
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }

}

// MARK: - Constants

extension AccountViewController {
    
    enum Constants {
        static let shadowOpacity: Float = 0.25
    }
    
}
