//
//  VocabularyInfoView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class VocabularyInfoView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var selectCategoryButton: UIButton!
    
    // MARK: - Public properties
    // MARK: - Private properties
    // MARK: - Lifecycle
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    
    var selectCategoryHandler: ((UIView) -> String)?
    
    // MARK: - Private methods
    // MARK: - Actions
    
    @IBAction
    private func didSelectCategoryTouch(_ sender: UIButton) {
        selectCategoryButton.setTitle(selectCategoryHandler?(sender), for: .normal)
    }
    
}
