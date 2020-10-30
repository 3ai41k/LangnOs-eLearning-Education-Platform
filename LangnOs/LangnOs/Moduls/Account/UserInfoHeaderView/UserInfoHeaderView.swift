//
//  UserInfoHeaderView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class UserInfoHeaderView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = imageView.bounds.height / 2.0
        }
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    // MARK: - Public properties
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                activityIndicator.stopAnimating()
            } else {
                imageView.image = nil
                activityIndicator.startAnimating()
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var email: String? {
        didSet {
            emailLabel.text = email
        }
    }
    
    var editImageHandler: (() ->Void)?
    
    // MARK: - Actions
    
    @IBAction
    private func didEditImageTouch(_ sender: Any) {
        editImageHandler?()
    }
    
    
}
