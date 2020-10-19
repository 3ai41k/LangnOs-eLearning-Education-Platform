//
//  WritingProgressView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 19.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

@IBDesignable
final class WritingProgressView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var firstProgressView: UIView!
    @IBOutlet private weak var secondProgressView: UIView!
    
    // MARK: - Public properties
    
    var correctAnswers = 0 {
        didSet {
            if correctAnswers == 0 {
                firstProgressView.backgroundColor = .lightGray
                secondProgressView.backgroundColor = .lightGray
            }
            
            if correctAnswers == 1 {
                firstProgressView.backgroundColor = .green
            }
            
            if correctAnswers == 2 {
                secondProgressView.backgroundColor = .green
            }
        }
    }
    
}
