//
//  FirebaseDatabaseEntityProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 03.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol FDEntityProtocol {
    init(dictionary: [String: Any])
    var serialize: [String: Any] { get }
}