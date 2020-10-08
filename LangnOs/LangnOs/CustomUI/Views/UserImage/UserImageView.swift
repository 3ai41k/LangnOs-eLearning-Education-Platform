//
//  UserImageView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class UserImageView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Public properties
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2.0
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions


}
