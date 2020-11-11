//
//  UIView+Extensions.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIView {

    // Usage:
    //
    // let customView: CustomViewClass = .fromNib()
    //
    static func fromNib<T: UIView>(_ nibName: String = "\(T.self)") -> T? {
        let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T
        #if DEBUG
        if view == nil{
            print("\(T.self).xib could not be found!")
        }
        #endif
        return view
    }
    
}
