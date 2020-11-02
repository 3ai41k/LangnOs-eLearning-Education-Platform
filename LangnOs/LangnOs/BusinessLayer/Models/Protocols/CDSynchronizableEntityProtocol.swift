//
//  CDSynchronizableEntityProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol CDSynchronizableEntityProtocol: CDEntityProtocol {
    var isSynchronized: Bool { get set }
}
