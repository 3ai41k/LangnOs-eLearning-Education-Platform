//
//  InputViewDrivableModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

struct InputViewDrivableModel: DrivableModelProtocol {
    let text: String?
    let placeholder: String
    let textDidEnter: (String) -> Void
}
