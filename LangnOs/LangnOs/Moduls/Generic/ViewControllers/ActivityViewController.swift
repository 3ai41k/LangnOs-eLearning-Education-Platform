//
//  ActivityViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class ActivityViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20.0
        }
    }
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
}
