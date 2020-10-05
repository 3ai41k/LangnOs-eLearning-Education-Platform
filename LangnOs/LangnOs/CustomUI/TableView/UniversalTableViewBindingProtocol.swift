//
//  UniversalTableViewBindingProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol UniversalTableViewBindingProtocol {
    var reloadData: (() -> Void)? { get set }
}
