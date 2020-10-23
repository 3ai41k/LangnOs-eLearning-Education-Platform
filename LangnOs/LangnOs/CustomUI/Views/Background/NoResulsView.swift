//
//  NoResulsView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 13.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class NoResulsView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Public properties
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
    

}
