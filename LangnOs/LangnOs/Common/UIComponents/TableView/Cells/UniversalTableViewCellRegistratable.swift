//
//  UniversalTableViewCellRegistratable.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol UniversalTableViewCellRegistratable where Self: UITableViewCell {
    static var identifier: String { get }
    static var nib: UINib { get }
    static func register(_ tableView: UITableView)
    static func dequeueReusableCell(_ tableView: UITableView, for indexPath: IndexPath) -> Self
}

extension UniversalTableViewCellRegistratable {
    
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static func register(_ tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    static func dequeueReusableCell(_ tableView: UITableView, for indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Self
    }
    
}
