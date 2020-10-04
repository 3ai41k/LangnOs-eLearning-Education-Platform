//
//  UniversalTableViewInputProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol UniversalTableViewInputProtocol {
    var numberOfRows: Int { get }
    func cellViewModelForRowAt(indexPath: IndexPath) -> CellViewModelProtocol
}
