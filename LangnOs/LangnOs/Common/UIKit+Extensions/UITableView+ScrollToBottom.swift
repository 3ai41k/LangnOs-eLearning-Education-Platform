//
//  UITableView+ScrollToBottom.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        let sectionIndex = numberOfSections != .zero ? numberOfSections - 1 : .zero
        let numberOfRowsInSection = numberOfRows(inSection: sectionIndex)
        
        guard numberOfRowsInSection != .zero else { return }
        
        let rowIndex = numberOfRowsInSection - 1
        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
        
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
}
