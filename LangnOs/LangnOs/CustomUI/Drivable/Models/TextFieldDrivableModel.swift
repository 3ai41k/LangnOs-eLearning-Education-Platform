//
//  TextFieldDrivableModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

struct TextFieldDrivableModel: DrivableModelProtocol {
    let placeholder: String
    let returnKey: UIReturnKeyType
    let contentType: UITextContentType
    
    init(placeholder: String, returnKey: UIReturnKeyType = .default, contentType: UITextContentType = .name) {
        self.placeholder = placeholder
        self.returnKey = returnKey
        self.contentType = contentType
    }
}
