//
//  String+Localize.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

extension String {
    
    var localize: String {
        NSLocalizedString(self, comment: "")
    }
    
}
