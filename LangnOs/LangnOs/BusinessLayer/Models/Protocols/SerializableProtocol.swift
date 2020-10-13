//
//  SerializableProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 13.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol SerializableProtocol {
    var serialize: [String: Any] { get }
}
