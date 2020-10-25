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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var bottomCardView: UIView! {
        didSet {
            bottomCardView.layer.cornerRadius = 20.0
            bottomCardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            bottomCardView.setShadow(color: .black, opacity: Constants.shadowOpacity)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.actionSubject.send(.downloadUserImage)
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.initials.assign(to: \.text, on: userNameLabel),
            viewModel?.email.assign(to: \.text, on: userEmailLabel),
            viewModel?.userImage.assign(to: \.image, on: userImageView),
            viewModel?.isImageActivityIndicatorHidden.sink(receiveValue: { [weak self] isHidden in
                if isHidden {
                    self?.activityIndicator.stopAnimating()
                } else {
                    self?.activityIndicator.startAnimating()
                }
            }),
            viewModel?.reloadUI.sink(receiveValue: { [weak self] in
                self?.setupUI()
            })
        ]
    }
    
    override func setupUI() {
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
